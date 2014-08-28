require 'spec_helper'

describe Concerns::Twitter, :type => :model do
  let(:user) { create(:user) }

  describe "#authorize_twitter!" do
    it "configures the twitter client" do
      expect(user).to receive(:twitter_nickname=).with(:nickname)
      expect(user).to receive(:twitter_token=).with(:token)
      expect(user).to receive(:twitter_secret=).with(:secret)
      expect(user).to receive(:save!)

      user.authorize_twitter!(:nickname, :token, :secret)
    end
  end


  describe "#remove_twitter!" do
    it "configures the twitter client" do
      [:twitter_nickname=, :twitter_token=, :twitter_secret= ].each do |method|
        expect(user).to receive(method).with(nil)
      end
      expect(user).to receive(:save!)

      user.remove_twitter!
    end

    describe "#twitter_linked?" do
      it "checks if twitter is configured" do
        user.twitter_token = :token
        user.twitter_secret = :secret

        expect(user.twitter_linked?).to eq(true)
      end

    end
  end
end
