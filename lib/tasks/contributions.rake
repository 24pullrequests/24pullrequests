namespace :contributions do
  namespace :normalize_legacy_timestamps do
    desc 'Dry run legacy contribution timestamp normalization'
    task dry_run: :environment do
      max_id = parse_max_id(ENV['MAX_ID'])
      year = parse_year(ENV['YEAR'])
      sample_size = ENV['SAMPLE_SIZE'].present? ? ENV['SAMPLE_SIZE'].to_i : 20
      user_ids = parse_user_ids(ENV['USER_IDS'])

      scope = contributions_legacy_scope(max_id: max_id, year: year, user_ids: user_ids)
      total_candidates = scope.count
      valid_timezone_candidates = 0
      sample_rows = []

      scope.find_each do |contribution|
        zone = Time.find_zone(contribution.user.time_zone)
        next unless zone

        valid_timezone_candidates += 1
        next unless sample_rows.length < sample_size

        normalized_timestamp = normalize_contribution_legacy_timestamp(contribution, zone)
        sample_rows << [
          contribution.id,
          contribution.user_id,
          contribution.created_at.utc.iso8601,
          normalized_timestamp.utc.iso8601,
          zone.name
        ]
      end

      puts "Legacy contribution timestamp dry run"
      puts "MAX_ID: #{max_id || 'not set'}"
      puts "YEAR: #{year}"
      puts "USER_IDS: #{user_ids&.join(',') || 'not set'}"
      puts "Candidates: #{total_candidates}"
      puts "Candidates with valid user timezone: #{valid_timezone_candidates}"
      puts "Sample rows (id,user_id,old_utc,new_utc,user_time_zone):"
      sample_rows.each { |row| puts row.join(',') }
      puts "No rows sampled." if sample_rows.empty?
    end

    desc 'Normalize legacy contribution timestamps'
    task apply: :environment do
      abort 'USER_IDS is required for apply (example: USER_IDS=1,2,3)' unless ENV['USER_IDS'].present?
      abort 'ASSUME_CURRENT_TIMEZONE=true is required for apply' unless ENV['ASSUME_CURRENT_TIMEZONE'] == 'true'

      max_id = parse_max_id(ENV['MAX_ID'], required: true)
      year = parse_year(ENV['YEAR'])
      batch_size = parse_batch_size(ENV['BATCH_SIZE'])
      user_ids = parse_user_ids(ENV['USER_IDS'], required: true)

      scope = contributions_legacy_scope(max_id: max_id, year: year, user_ids: user_ids)
      updated_count = 0
      skipped_invalid_timezone = 0
      skipped_already_normalized = 0
      skipped_no_change = 0

      scope.find_in_batches(batch_size: batch_size).with_index do |batch, index|
        normalized_ids = ContributionTimestampNormalization
          .where(contribution_id: batch.map(&:id))
          .pluck(:contribution_id)
          .each_with_object({}) { |contribution_id, memo| memo[contribution_id] = true }

        batch.each do |contribution|
          if normalized_ids[contribution.id]
            skipped_already_normalized += 1
            next
          end

          zone = Time.find_zone(contribution.user.time_zone)
          unless zone
            skipped_invalid_timezone += 1
            next
          end

          normalized_timestamp = normalize_contribution_legacy_timestamp(contribution, zone)
          original_timestamp = contribution.created_at
          Contribution.transaction do
            if original_timestamp == normalized_timestamp
              skipped_no_change += 1
            else
              contribution.update_column(:created_at, normalized_timestamp)
              updated_count += 1
            end

            ContributionTimestampNormalization.create!(
              contribution_id: contribution.id,
              original_created_at: original_timestamp,
              normalized_created_at: normalized_timestamp,
              applied_timezone: zone.name,
              normalized_at: Time.current
            )
          end
        end

        puts "Processed batch #{index + 1} (updated=#{updated_count}, skipped_no_change=#{skipped_no_change}, skipped_invalid_timezone=#{skipped_invalid_timezone}, skipped_already_normalized=#{skipped_already_normalized})"
      end

      recounted_users = recount_contribution_counts!(user_ids)
      puts "Done. Updated #{updated_count} contributions (skipped_no_change=#{skipped_no_change}, skipped_invalid_timezone=#{skipped_invalid_timezone}, skipped_already_normalized=#{skipped_already_normalized}, recounted_users=#{recounted_users})."
    end
  end
end

def contributions_legacy_scope(max_id:, year:, user_ids: nil)
  scope = Contribution
    .eager_load(:user)
    .where.not(state: nil)
    .where.not(users: { time_zone: [nil, ''] })
    .where.not(id: ContributionTimestampNormalization.select(:contribution_id))

  scope = scope.where('contributions.id <= ?', max_id) if max_id.present?
  scope = scope.where('EXTRACT(year FROM contributions.created_at) = ?', year) if year.present?
  scope = scope.where(user_id: user_ids) if user_ids.present?
  scope.order('contributions.id asc')
end

def normalize_contribution_legacy_timestamp(contribution, zone)
  timestamp = contribution.created_at.utc
  zone.local(timestamp.year, timestamp.month, timestamp.day, timestamp.hour, timestamp.min, timestamp.sec, timestamp.usec).utc
end

def parse_max_id(raw_max_id, required: false)
  max_id = raw_max_id.to_s.strip
  if max_id.empty?
    abort 'MAX_ID is required for apply (example: MAX_ID=12345)' if required
    return nil
  end
  abort 'MAX_ID must be an integer ID (example: MAX_ID=12345)' unless max_id.match?(/\A\d+\z/)

  max_id.to_i
end

def parse_year(raw_year)
  year = raw_year.to_s.strip
  return Tfpullrequests::Application.current_year if year.empty?
  abort 'YEAR must be a positive integer year (example: YEAR=2025)' unless year.match?(/\A\d+\z/) && year.to_i.positive?

  year.to_i
end

def parse_batch_size(raw_batch_size)
  batch_size = raw_batch_size.to_s.strip
  return 1000 if batch_size.empty?
  abort 'BATCH_SIZE must be a positive integer (example: BATCH_SIZE=1000)' unless batch_size.match?(/\A\d+\z/) && batch_size.to_i.positive?

  batch_size.to_i
end

def parse_user_ids(raw_user_ids, required: false)
  user_ids = raw_user_ids.to_s.split(',').collect(&:strip).reject(&:blank?)
  if user_ids.empty?
    abort 'USER_IDS must contain at least one integer ID (example: USER_IDS=1,2,3)' if required
    return nil
  end
  abort 'USER_IDS must be a comma-separated list of integer IDs (example: USER_IDS=1,2,3)' unless user_ids.all? { |id| id.match?(/\A\d+\z/) }

  user_ids.collect(&:to_i).uniq
end

def recount_contribution_counts!(user_ids)
  return 0 if user_ids.empty?

  recounted_users = 0
  User.where(id: user_ids).find_each do |user|
    user.update_contribution_count
    recounted_users += 1
  end
  recounted_users
end
