require 'rails_helper'

describe 'Gifts', :type => :request do
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
      is_expected.not_to have_xpath "//option[contains(text(), 'Gifted')]"
      is_expected.to have_xpath "//option[contains(text(), 'Not gifted: #{pull_request.repo_name}')]"
    end

    context "tweeting" do
      it "posts a tweet when the user selects 'tweet'" do
        expect_any_instance_of(PullRequest).to receive(:post_tweet)

        select_from "gift_date", 0
        select_from "gift_pull_request_id", 1

        check "gift_tweet"
      end

      it "does not post a tweet when 'tweet' is not selected" do
        expect_any_instance_of(PullRequest).not_to receive(:post_tweet)

        select_from "gift_date", 0
        select_from "gift_pull_request_id", 1
      end

      after do
        click_on "Gift it!"
      end
    end
  end
end
