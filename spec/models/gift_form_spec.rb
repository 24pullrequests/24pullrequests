require 'rails_helper'

describe GiftForm, type: :model do
  let(:gift)               { create :gift }
  let(:contribution)       { create :contribution }
  let(:old_contribution)   { create(:contribution, created_at: DateTime.new(2012, 12, 2)) }
  let(:contributions)      { [contribution, old_contribution] }
  let(:date)               { Time.zone.now.to_s }
  let(:giftable_dates)     { Gift.giftable_dates }
  let(:gift_form) do
    described_class.new gift:           gift,
                        giftable_dates: giftable_dates,
                        contributions:  contributions,
                        date:           date
  end

  describe '.contributions_for_select' do
    subject { gift_form.contributions_for_select }

    context 'when a pull request has not been gifted' do
      it { is_expected.to include ["Not gifted: #{contribution.repo_name} - #{contribution.title}", contribution.to_param] }
    end

    context 'when a pull request has been gifted' do
      let(:contribution) { gift.contribution }
      it { is_expected.to include ["Gifted: #{contribution.repo_name} - #{contribution.title}", contribution.to_param] }
    end

    context 'when a pull request is old' do
      it { is_expected.not_to include ["Not gifted: #{old_contribution.repo_name} - #{old_contribution.title}", old_contribution.to_param] }
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
