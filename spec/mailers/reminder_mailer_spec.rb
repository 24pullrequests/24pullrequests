require 'spec_helper'

describe ReminderMailer, type: :mailer do

  describe 'daily' do
    let(:user) do
      mock_model(User, nickname:           'David',
                       email:              'david@example.com',
                       languages:          ['Ruby'],
                       skills:             [],
                       pull_requests:      double(:pull_request, year: []),
                       suggested_projects: [])
    end
    let(:mail) { ReminderMailer.daily(user) }

    it 'renders the subject' do
      expect(mail.subject).to eq('[24 Pull Requests] Daily Reminder')
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

    it 'says daily' do
      expect(mail.body.encoded).to match('today')
    end

  end

  describe 'weekly' do
    let(:user) do
      mock_model(User, nickname:           'David',
                       email:              'david@example.com',
                       languages:          ['Ruby'],
                       skills:             [],
                       pull_requests:      double(:pull_request, year: []),
                       suggested_projects: [])
    end
    let(:mail) { ReminderMailer.weekly(user) }

    it 'renders the subject' do
      expect(mail.subject).to eq('[24 Pull Requests] Weekly Reminder')
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

    it 'says weekly' do
      expect(mail.body.encoded).to match('week')
    end

  end

end
