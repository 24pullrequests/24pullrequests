require 'rails_helper'

describe ReminderMailer, type: :mailer do
  let(:user) do
    allow(Project).to receive_message_chain(:order, :limit).and_return(Project.where(nil))

    mock_model(User,
    {
      nickname: 'David',
      email: 'david@example.com',
      languages: ['Ruby'],
      skills: [],
      pull_requests: double(:pull_request, year: []),
      suggested_projects: Project.all,
    })
  end

  shared_examples :reminder_mailer do |subject:, this_time:, next_time:|
    it 'renders the subject' do
      expect(mail.subject).to eq(subject)
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

    it 'contains periodicity in body' do
      expect(mail.body.encoded).to match("We've got some suggested projects for you to send pull requests to #{this_time}")
      expect(mail.body.encoded).to match("See you #{next_time}!")
      expect(mail.body.encoded).to_not match("See you next #{next_time}!")
    end
  end

  describe 'daily' do
    let(:mail) { ReminderMailer.daily(user) }

    it_behaves_like :reminder_mailer,
      subject: '[24 Pull Requests] Daily Reminder',
      this_time: 'today',
      next_time: 'tomorrow'
  end

  describe 'weekly' do
    let(:mail) { ReminderMailer.weekly(user) }

    it_behaves_like :reminder_mailer,
      subject: '[24 Pull Requests] Weekly Reminder',
      this_time: 'this week',
      next_time: 'next week'
  end
end
