require 'spec_helper'

describe GiftForm, :type => :model do
  let(:gift)           { create :gift }
  let(:pull_request)   { create :pull_request }
  let(:pull_requests)  { [pull_request] }
  let(:date)           { Time.zone.now.to_s }
  let(:giftable_dates) { Gift.giftable_dates }
  let(:gift_form) do
    described_class.new :gift => gift,
      :giftable_dates => giftable_dates,
      :pull_requests => pull_requests,
      :date => date
  end

  describe '.pull_requests_for_select' do
    subject { gift_form.pull_requests_for_select }

    context 'when a pull request has not been gifted' do
      it { is_expected.to include ["Not gifted: #{pull_request.repo_name} - #{pull_request.title}", pull_request.to_param] }
    end

    context 'when a pull request has been gifted' do
      let(:pull_request) { gift.pull_request }
      it { is_expected.to include ["Gifted: #{pull_request.repo_name} - #{pull_request.title}", pull_request.to_param] }
    end
  end

  describe '.show_date_select?' do
    subject { gift_form.show_date_select? }

    context 'when the giftable dates is not empty' do
      it { is_expected.to be true }
    end

    context 'when the giftable dates is empty' do
      let(:giftable_dates) { [] }
      it { is_expected.to be false }
    end
  end
end
