desc "Send daily emails"
task :send_emails => :environment do
  next unless PullRequest.in_date_range?
  User.all.each {|u| u.send_notification_email rescue nil } if Time.now.utc >= Date.parse("#{CURRENT_YEAR}-12-01") && Time.now.utc < Date.parse("#{CURRENT_YEAR}-12-25")
end

desc "export emails for mailchimp"
task :export_emails => :environment do
  users = User.where('email is not null').reject{|u| u.email.blank?}

  csv_string = CsvShaper.encode do |csv|
    csv.headers :nickname, :email

    csv.rows users do |csv, user|
      csv.cells :nickname, :email
    end
  end

  puts csv_string
end
