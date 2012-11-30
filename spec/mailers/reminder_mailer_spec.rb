require "spec_helper"

describe ReminderMailer do
  
  describe 'daily' do
    let(:user) { mock_model(User, :nickname => 'David', :email => 'david@example.com') }
    let(:mail) { ReminderMailer.daily(user) }
 
    it 'renders the subject' do
      mail.subject.should == '[24 Pull Requests] Daily Reminder'
    end
 
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
 
    it 'renders the sender email' do
      mail.from.should == ['noreply@24pullrequests.com']
    end
 
    it 'uses nickname' do
      mail.body.encoded.should match(user.nickname)
    end

    it 'says daily' do
      mail.body.encoded.should match("daily")
    end

  end

  describe 'weekly' do
    let(:user) { mock_model(User, :nickname => 'David', :email => 'david@example.com') }
    let(:mail) { ReminderMailer.weekly(user) }
 
    it 'renders the subject' do
      mail.subject.should == '[24 Pull Requests] Weekly Reminder'
    end
 
    it 'renders the receiver email' do
      mail.to.should == [user.email]
    end
 
    it 'renders the sender email' do
      mail.from.should == ['noreply@24pullrequests.com']
    end
 
    it 'uses nickname' do
      mail.body.encoded.should match(user.nickname)
    end

    it 'says weekly' do
      mail.body.encoded.should match("weekly")
    end

  end

end
