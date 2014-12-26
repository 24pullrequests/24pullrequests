require 'rails_helper'

describe Concerns::PullReview, type: :model do
  let(:user) { create(:user) }

  describe 'award_pullreview_coupon' do
    before do
      3.times { create(:pull_request, user: user) }
      ENV['PULLREVIEW_COUPON'] = 'PULLREVIEW_COUPON'
    end

    it 'does not award PullReview coupon when less than 24 PRs' do
      expect(user.award_pullreview_coupon).to be_nil
    end

    it 'does not award PullReview coupon when not configured' do
      ENV['PULLREVIEW_COUPON'] = nil
      expect(user.award_pullreview_coupon).to be_nil
    end

    it 'awards PullReview coupon when 24 PRs' do
      21.times { create(:pull_request, user: user) }

      expect(user.award_pullreview_coupon).to eq(ENV['PULLREVIEW_COUPON'])
    end

  end
end