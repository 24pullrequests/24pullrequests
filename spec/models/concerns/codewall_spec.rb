require 'rails_helper'

describe Concerns::Coderwall, :type => :model do
  let(:user) { create(:user) }

  describe "#coderwall_username" do
    it "returns the coderwall_user_name when it is set" do
      expect(user).to receive(:coderwall_user_name)

      user.coderwall_username
    end

    it "return the nickname when coderwall_user_name is not set" do
      user.coderwall_user_name = nil
      expect(user).to receive(:nickname)

      user.coderwall_username
    end
  end

  describe "#change_coderwall_username!" do
    it "updates the coderwall username" do
      expect(user).to receive(:update_attributes!).with(coderwall_user_name: :username)

      user.change_coderwall_username!(:username)
    end
  end

  describe "award_coderwall_badges" do
    before do
      3.times { create(:pull_request, user: user) }
    end

    it "awards PARTICIPANT badges" do
      coderwall = double(:coderwall, :configured? => true)
      2.times { expect(user).to receive(:coderwall).and_return(coderwall) }
      expect(coderwall).to receive(:award_badge).with(user.coderwall_username, ::Coderwall::PARTICIPANT)
      user.award_coderwall_badges
    end

    it "awards PARTICIPANT and CONTINUOUS badges" do
      21.times { create(:pull_request, user: user) }

      coderwall = double(:coderwall, :configured? => true)
      3.times { expect(user).to receive(:coderwall).and_return(coderwall) }
      expect(coderwall).to receive(:award_badge).with(user.coderwall_username, ::Coderwall::PARTICIPANT)
      expect(coderwall).to receive(:award_badge).with(user.coderwall_username, ::Coderwall::CONTINUOUS)
      user.award_coderwall_badges
    end
  end
end
