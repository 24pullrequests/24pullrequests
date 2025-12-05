require 'rails_helper'

describe Notification do

  subject(:user) { FactoryBot.create(:user, email_frequency: 'daily') }
  subject(:notification)  { Notification.new(user) }

  describe '#send_email' do

    it 'does not email an unconfirmed user' do
      expect(ReminderMailer).not_to receive(:daily)

      notification.send_email
      expect(user.last_sent_at).to eq(nil)
    end

    context 'sends notifications' do
      let(:mailer) { double(:reminder_mailer, deliver_now: nil, weekly: nil) }

      before do
        user.confirm!
      end

      context '#daily' do
        it 'sends an email' do
          expect(ReminderMailer).to receive(:daily).with(user).and_return(mailer)

          notification.send_email
        end

        it 'once per day' do
          other_notification = Notification.new(user)

          2.times { expect(notification).to receive(:daily?).and_return(true) }
          expect(other_notification).to receive(:daily?).and_return(false)

          notification.send_email
          other_notification.send_email
        end
      end

      context '#weekly' do
        before do
          user.update_column(:email_frequency, 'weekly')
        end

        it 'sends an email' do
          expect(ReminderMailer).to receive(:weekly).with(user).and_return(mailer)

          notification.send_email
        end

        it 'once per week' do
          other_notification = Notification.new(user)

          expect(notification).to receive(:weekly?).and_return(true)
          expect(other_notification).to receive(:weekly?).and_return(false)

          notification.send_email
          other_notification.send_email
        end
      end

      context 'when email delivery fails' do
        it 'does not raise an error' do
          mailer = double(:reminder_mailer)
          allow(mailer).to receive(:deliver_now).and_raise(ArgumentError, 'SMTP-AUTH requested but missing user name')
          allow(ReminderMailer).to receive(:daily).with(user).and_return(mailer)

          expect { notification.send_email }.not_to raise_error
        end

        it 'does not update last_sent_at' do
          mailer = double(:reminder_mailer)
          allow(mailer).to receive(:deliver_now).and_raise(ArgumentError, 'SMTP-AUTH requested but missing user name')
          allow(ReminderMailer).to receive(:daily).with(user).and_return(mailer)

          notification.send_email
          expect(user.reload.last_sent_at).to be_nil
        end
      end
    end
  end
end
