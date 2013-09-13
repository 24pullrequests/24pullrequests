require 'spec_helper'

describe ConfirmationMailer do
  describe 'confirmation' do
    let(:token) { 'abcdefg12345' }
    let(:user) { mock_model(User, :nickname => 'David',
                                  :email => 'david@example.com',
                                  :confirmation_token => token) }
    let(:mail) { ConfirmationMailer.confirmation(user) }

    it 'renders the subject' do
      expect(mail.subject).to eq '[24 Pull Requests] Email Confirmation'
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq [user.email]
    end

    it 'renders the sender email' do
      expect(mail['From'].to_s).to eq '24 Pull Requests <info@24pullrequests.com>'
    end

    it 'uses nickname' do
      expect(mail.body.encoded).to match(user.nickname)
    end

    it 'includes the confirmation token' do
      expect(mail.body.encoded).to match(token)
    end
  end
end
