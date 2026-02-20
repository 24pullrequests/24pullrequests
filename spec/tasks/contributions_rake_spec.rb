require 'rails_helper'
require 'rake'

describe 'contributions:normalize_legacy_timestamps' do
  before(:all) do
    Rails.application.load_tasks unless Rake::Task.task_defined?('contributions:normalize_legacy_timestamps:dry_run')
  end

  around do |example|
    original_max_id = ENV['MAX_ID']
    original_year = ENV['YEAR']
    original_batch_size = ENV['BATCH_SIZE']
    original_sample_size = ENV['SAMPLE_SIZE']
    original_user_ids = ENV['USER_IDS']
    original_assume_current_timezone = ENV['ASSUME_CURRENT_TIMEZONE']

    example.run
  ensure
    ENV['MAX_ID'] = original_max_id
    ENV['YEAR'] = original_year
    ENV['BATCH_SIZE'] = original_batch_size
    ENV['SAMPLE_SIZE'] = original_sample_size
    ENV['USER_IDS'] = original_user_ids
    ENV['ASSUME_CURRENT_TIMEZONE'] = original_assume_current_timezone
  end

  let(:dry_run_task) { Rake::Task['contributions:normalize_legacy_timestamps:dry_run'] }
  let(:apply_task) { Rake::Task['contributions:normalize_legacy_timestamps:apply'] }
  let(:user) { create(:user, time_zone: 'Pacific Time (US & Canada)') }
  let(:legacy_timestamp) { Time.utc(2025, 12, 3, 23, 30, 0) }
  let(:normalized_timestamp) { Time.utc(2025, 12, 4, 7, 30, 0) }
  let!(:contribution) { create(:contribution, user: user, created_at: legacy_timestamp) }

  before do
    dry_run_task.reenable
    apply_task.reenable
  end

  it 'does not modify data during dry run' do
    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = '2025'

    expect {
      dry_run_task.invoke
    }.to_not change { contribution.reload.created_at.to_i }
  end

  it 'excludes already normalized contributions from dry run candidates' do
    ContributionTimestampNormalization.create!(
      contribution: contribution,
      original_created_at: legacy_timestamp,
      normalized_created_at: normalized_timestamp,
      applied_timezone: 'Pacific Time (US & Canada)',
      normalized_at: Time.current
    )
    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = '2025'

    expect {
      dry_run_task.invoke
    }.to output(/Candidates: 0/).to_stdout
  end

  it 'normalizes legacy timestamps during apply' do
    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = '2025'
    ENV['BATCH_SIZE'] = '1'
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    apply_task.invoke

    expect(contribution.reload.created_at.to_i).to eq(normalized_timestamp.to_i)
  end

  it 'normalizes timestamps from UTC components regardless of current Time.zone' do
    precise_legacy_timestamp = Time.utc(2025, 12, 3, 23, 30, 0, 123_456)
    precise_normalized_timestamp = Time.utc(2025, 12, 4, 7, 30, 0, 123_456)
    contribution.update_column(:created_at, precise_legacy_timestamp)

    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = '2025'
    ENV['BATCH_SIZE'] = '1'
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    Time.use_zone('Pacific Time (US & Canada)') do
      apply_task.invoke
    end

    expect(contribution.reload.created_at.utc).to eq(precise_normalized_timestamp)
  end

  it 'requires MAX_ID for apply' do
    ENV['MAX_ID'] = nil
    ENV['YEAR'] = '2025'
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    expect {
      apply_task.invoke
    }.to raise_error(SystemExit)
  end

  it 'requires MAX_ID to be an integer ID' do
    ENV['MAX_ID'] = 'abc'
    ENV['YEAR'] = '2025'
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    expect {
      apply_task.invoke
    }.to raise_error(SystemExit)
  end

  it 'requires YEAR to be a positive integer year' do
    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = 'abc'
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    expect {
      apply_task.invoke
    }.to raise_error(SystemExit)
  end

  it 'requires YEAR to be greater than zero' do
    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = '0'
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    expect {
      apply_task.invoke
    }.to raise_error(SystemExit)
  end

  it 'requires USER_IDS for apply' do
    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = '2025'
    ENV['USER_IDS'] = nil
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    expect {
      apply_task.invoke
    }.to raise_error(SystemExit)
  end

  it 'requires USER_IDS to be integer IDs' do
    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = '2025'
    ENV['USER_IDS'] = 'abc,123'
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    expect {
      apply_task.invoke
    }.to raise_error(SystemExit)
  end

  it 'requires USER_IDS to contain at least one ID' do
    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = '2025'
    ENV['USER_IDS'] = ','
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    expect {
      apply_task.invoke
    }.to raise_error(SystemExit)
  end

  it 'requires USER_IDS to contain at least one non-blank ID' do
    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = '2025'
    ENV['USER_IDS'] = ' , '
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    expect {
      apply_task.invoke
    }.to raise_error(SystemExit)
  end

  it 'requires BATCH_SIZE to be a positive integer' do
    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = '2025'
    ENV['BATCH_SIZE'] = 'abc'
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    expect {
      apply_task.invoke
    }.to raise_error(SystemExit)
  end

  it 'requires BATCH_SIZE to be greater than zero' do
    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = '2025'
    ENV['BATCH_SIZE'] = '0'
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    expect {
      apply_task.invoke
    }.to raise_error(SystemExit)
  end

  it 'requires ASSUME_CURRENT_TIMEZONE for apply' do
    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = '2025'
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = nil

    expect {
      apply_task.invoke
    }.to raise_error(SystemExit)
  end

  it 'requires ASSUME_CURRENT_TIMEZONE to be literal true' do
    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = '2025'
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'typo'

    expect {
      apply_task.invoke
    }.to raise_error(SystemExit)
  end

  it 'requires ASSUME_CURRENT_TIMEZONE to be lowercase true' do
    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = '2025'
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'TRUE'

    expect {
      apply_task.invoke
    }.to raise_error(SystemExit)
  end

  it 'skips contributions for users with invalid timezones' do
    user.update_column(:time_zone, 'Invalid/Timezone')
    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = '2025'
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    expect {
      apply_task.invoke
    }.to_not change { contribution.reload.created_at.to_i }
  end

  it 'updates only contributions for selected users' do
    other_user = create(:user, time_zone: 'Pacific Time (US & Canada)')
    other_contribution = create(:contribution, user: other_user, created_at: legacy_timestamp)

    ENV['MAX_ID'] = other_contribution.id.to_s
    ENV['YEAR'] = '2025'
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    apply_task.invoke

    expect(contribution.reload.created_at.to_i).to eq(normalized_timestamp.to_i)
    expect(other_contribution.reload.created_at.to_i).to eq(legacy_timestamp.to_i)
  end

  it 'recounts contribution counts for updated users' do
    current_year = Tfpullrequests::Application.current_year
    boundary_crossing_legacy_timestamp = Time.utc(current_year, 11, 30, 20, 30, 0)
    boundary_crossing_normalized_timestamp = Time.utc(current_year, 12, 1, 4, 30, 0)
    contribution.update_column(:created_at, boundary_crossing_legacy_timestamp)
    user.update_column(:contributions_count, 0)

    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = current_year.to_s
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    apply_task.invoke

    expect(contribution.reload.created_at.to_i).to eq(boundary_crossing_normalized_timestamp.to_i)
    expect(user.reload.contributions_count).to eq(1)
  end

  it 'is idempotent when apply is run repeatedly' do
    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = '2025'
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    apply_task.invoke
    first_run_timestamp = contribution.reload.created_at

    apply_task.reenable
    apply_task.invoke

    expect(contribution.reload.created_at.to_i).to eq(first_run_timestamp.to_i)
  end

  it 'records normalization metadata when updating timestamps' do
    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = '2025'
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    apply_task.invoke

    normalization = ContributionTimestampNormalization.find_by(contribution_id: contribution.id)
    expect(normalization).to be_present
    expect(normalization.original_created_at.to_i).to eq(legacy_timestamp.to_i)
    expect(normalization.normalized_created_at.to_i).to eq(normalized_timestamp.to_i)
    expect(normalization.applied_timezone).to eq('Pacific Time (US & Canada)')
  end

  it 'records normalization metadata when timestamp is already normalized' do
    user.update_column(:time_zone, 'UTC')

    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = '2025'
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    apply_task.invoke

    normalization = ContributionTimestampNormalization.find_by(contribution_id: contribution.id)
    expect(normalization).to be_present
    expect(normalization.original_created_at.to_i).to eq(legacy_timestamp.to_i)
    expect(normalization.normalized_created_at.to_i).to eq(legacy_timestamp.to_i)
    expect(normalization.applied_timezone).to eq('UTC')

    user.update_column(:time_zone, 'Pacific Time (US & Canada)')

    apply_task.reenable
    apply_task.invoke

    expect(contribution.reload.created_at.to_i).to eq(legacy_timestamp.to_i)
    expect(ContributionTimestampNormalization.where(contribution_id: contribution.id).count).to eq(1)
  end

  it 'recounts users even when contributions are already normalized' do
    current_year = Tfpullrequests::Application.current_year
    contribution.update_column(:created_at, Time.utc(current_year, 11, 30, 20, 30, 0))

    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = current_year.to_s
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    apply_task.invoke
    user.update_column(:contributions_count, 0)

    apply_task.reenable
    apply_task.invoke

    expect(user.reload.contributions_count).to eq(1)
  end

  it 'recounts specified users when normalized timestamps move out of YEAR scope' do
    current_year = Tfpullrequests::Application.current_year
    year_end_legacy_timestamp = Time.utc(current_year, 12, 31, 20, 30, 0)
    year_rollover_normalized_timestamp = Time.utc(current_year + 1, 1, 1, 4, 30, 0)
    contribution.update_column(:created_at, year_end_legacy_timestamp)

    ENV['MAX_ID'] = contribution.id.to_s
    ENV['YEAR'] = current_year.to_s
    ENV['USER_IDS'] = user.id.to_s
    ENV['ASSUME_CURRENT_TIMEZONE'] = 'true'

    apply_task.invoke
    expect(contribution.reload.created_at.to_i).to eq(year_rollover_normalized_timestamp.to_i)

    user.update_column(:contributions_count, 1)

    apply_task.reenable
    apply_task.invoke

    expect(user.reload.contributions_count).to eq(0)
  end

  it 'removes normalization rows when contribution is destroyed' do
    normalization = ContributionTimestampNormalization.create!(
      contribution: contribution,
      original_created_at: legacy_timestamp,
      normalized_created_at: normalized_timestamp,
      applied_timezone: 'Pacific Time (US & Canada)',
      normalized_at: Time.current
    )

    expect {
      contribution.destroy!
    }.to change { ContributionTimestampNormalization.where(id: normalization.id).count }.from(1).to(0)
  end
end
