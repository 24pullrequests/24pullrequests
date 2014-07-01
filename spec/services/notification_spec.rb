describe Notification do

  subject(:user) { FactoryGirl.create(:user, email_frequency: 'daily') }
  subject(:notification)  { Notification.new(user) }


  describe "#send_email" do

    it "does not email an unconfirmed user" do
      ReminderMailer.should_not_receive(:daily)

      notification.send_email
      expect(user.last_sent_at).to eq(nil)
    end

    context "sends notifications" do
      let(:mailer) { double(:reminder_mailer, deliver: nil, weekly: nil) }

      before do
        user.confirm!
      end

      context "#daily" do
        it "sends an email" do
          ReminderMailer.should_receive(:daily).with(user).and_return(mailer)

          notification.send_email
        end

        it "once per day" do
          other_notification = Notification.new(user)

          2.times { notification.should_receive(:daily?).and_return(true) }
          other_notification.should_receive(:daily?).and_return(false)

          notification.send_email
          other_notification.send_email
        end
      end

      context "#weekly" do
        before do
          user.update_attribute(:email_frequency, 'weekly')
        end

        it "sends an email" do
          ReminderMailer.should_receive(:weekly).with(user).and_return(mailer)

          notification.send_email
        end

        it "once per week" do
          other_notification = Notification.new(user)

          notification.should_receive(:weekly?).and_return(true)
          other_notification.should_receive(:weekly?).and_return(false)

          notification.send_email
          other_notification.send_email
        end
      end
    end
  end
end
