require 'rails_helper'

describe Gift, type: :model do
  let(:gift) { create :gift }
  let(:contribution) { gift.contribution }
  let(:user) { gift.user }
  let(:date) { gift.date }

  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:contribution) }
  it { is_expected.to validate_presence_of(:date) }
  it { is_expected.to validate_inclusion_of(:date).in_array(Gift.giftable_dates).with_message('your gift should be for the month of December.') }

  describe '#find' do
    subject { described_class.find(user, Time.zone.now.to_date) }
    it { is_expected.to eq gift }
  end

  it 'raises a validation error when a gift has already been given for the current day' do
    expect do
      user.gifts.create!(contribution: create(:contribution), date: date)
    end.to raise_error ActiveRecord::RecordInvalid, 'Validation failed: Date you only need one gift per day. Save it for tomorrow!'
  end

  it "raises a validation error if the pull request has already been gifted" do
    expect do
      user.gifts.create!(contribution: contribution, date: date + 1.day)
    end.to raise_error ActiveRecord::RecordInvalid, 'Validation failed: Contribution you can only gift each contribution once!'
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

  describe 'timezone handling' do
    around do |example|
      # Save original timezone
      original_zone = Time.zone
      example.run
      # Restore original timezone
      Time.zone = original_zone
    end

    it 'uses current timezone for default_date' do
      Time.zone = 'Pacific Time (US & Canada)'
      pacific_date = Time.zone.now.to_date

      Time.zone = 'Eastern Time (US & Canada)'
      eastern_date = Time.zone.now.to_date

      # If it's a date boundary, these might differ
      # This test verifies that default_date uses Time.zone
      expect(Gift.default_date).to eq(eastern_date)
    end
  end
end
