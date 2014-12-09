require 'spec_helper'

describe ReminderMailer, type: :mailer do

  ['daily','weekly'].each do |time_format|
    describe time_format do
      let(:time_format) { time_format }
      let(:user) do
        mock_model(User, nickname:           'David',
                         email:              'david@example.com',
                         languages:          ['Ruby'],
                         skills:             [],
                         pull_requests:      double(:pull_request, year: []),
                         suggested_projects: [])
      end
          let(:mail) {
            if time_format == 'daily'
              ReminderMailer.daily(user)
            else
              ReminderMailer.weekly(user)
            end
          }

      it 'renders the subject' do
        expect(mail.subject).to eq("[24 Pull Requests] #{time_format.capitalize} Reminder")
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([user.email])
      end

      it 'renders the sender email' do
        expect(mail['From'].to_s).to eq('24 Pull Requests <info@24pullrequests.com>')
      end

      it 'uses nickname' do
        expect(mail.body.encoded).to match(user.nickname)
      end

      it "says #{time_format}" do
        if time_format == 'weekly'
          expect(mail.body.encoded).to match("We've got some suggested projects for you to send pull requests to this week")
          expect(mail.body.encoded).to match("See you next week!")
        elsif time_format == 'daily'
          expect(mail.body.encoded).to match("We've got some suggested projects for you to send pull requests to today")
          expect(mail.body.encoded).to match("See you tomorrow!")
        end
      end

    end
  end

end
