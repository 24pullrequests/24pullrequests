require 'spec_helper'

describe Gift, :type => :model do
  let(:gift) { create :gift }
  let(:pull_request) { gift.pull_request }
  let(:user) { gift.user }

  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:pull_request) }
  it { is_expected.to validate_presence_of(:date) }
  it { is_expected.to ensure_inclusion_of(:date).in_array(Gift.giftable_dates) }

  describe '#find' do
    subject { described_class.find(user, Time.zone.now.to_date)}
    it { is_expected.to eq gift }
  end

  it 'raises a validation error when a gift has already been given for the current day' do
    expect {
      user.gifts.create!(:pull_request => pull_request, :date => gift.date)
    }.to raise_error ActiveRecord::RecordInvalid, 'Validation failed: Date you only need one gift per day. Save it for tomorrow!'
  end

  describe '.date' do
    subject { gift.date }
    it 'should default to Gift.default_date' do
      is_expected.to eq Gift.default_date
    end
  end

  describe '.to_param' do
    subject { gift.to_param }
    it { is_expected.to eq gift.date.to_s }
  end
end
