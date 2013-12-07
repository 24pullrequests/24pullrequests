require 'spec_helper'

describe 'Gifts' do
  subject { page }
  let(:user) { create :user, nickname: "akira" }

  before do
    login(user)
  end

  describe 'gifting a pull request' do
    let!(:pull_request) { create(:pull_request, user: user) }
    let!(:gift) { create(:gift, user: user, date: Date.yesterday) }

    before do
      visit new_gift_path
    end

    it "only displays ungifted pull requests" do
      should_not have_xpath "//option[contains(text(), 'Gifted')]"
      should have_xpath "//option[contains(text(), 'Not gifted: #{pull_request.repo_name}')]"
    end

    context "tweeting" do
      it "posts a tweet when the user selects 'tweet'" do
        PullRequest.any_instance.should_receive(:post_tweet)

        select_from "gift_date", 0
        select_from "gift_pull_request_id", 1

        check "gift_tweet"
      end

      it "does not post a tweet when 'tweet' is not selected" do
        PullRequest.any_instance.should_not_receive(:post_tweet)

        select_from "gift_date", 0
        select_from "gift_pull_request_id", 1
      end

      after do
        click_on "Gift it!"
      end
    end
  end
end
