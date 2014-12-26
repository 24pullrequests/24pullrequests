module Concerns
  module PullReview
    def award_pullreview_coupon
      return unless coupon.present?
      return coupon if pull_requests.year(CURRENT_YEAR).length > 23
    end

    private

    def coupon
      @coupon ||= ENV['PULLREVIEW_COUPON']
    end
  end
end