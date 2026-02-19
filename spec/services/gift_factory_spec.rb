require 'rails_helper'

describe GiftFactory do
  let(:user) { FactoryBot.create(:user) }
  let(:contribution) { FactoryBot.create(:contribution) }
  let(:gift_factory) { Gift.public_method(:new) }

  describe "#create!" do
    it "generates a new gift for the user" do
      gift = GiftFactory.create!(user, gift_factory, contribution_id: contribution.id)
      expect(gift.contribution).to eq(contribution)
    end
  end

  describe '#create_from_attrs' do
    it 'creates a new present' do
      factory = GiftFactory.new(user, gift_factory)
      gift = factory.create_from_attrs({})

      expect(gift.date).to eq(Contribution::EARLIEST_PULL_DATE)
    end
  end

  context "when the user has gifted some PRs" do
    describe "#create_from_attrs" do
      before do
        user.gifts.create!({
          user: user,
          contribution: contribution,
          date: Date.new(Tfpullrequests::Application.current_year, 12, 5)
        })
      end

      it "creates a new present" do
        factory = GiftFactory.new(user, gift_factory)
        gift = factory.create_from_attrs({})

        expect(gift.date).to eq(Contribution::EARLIEST_PULL_DATE)
      end
    end
  end

  describe 'timezone boundary behavior' do
    let(:current_year) { Tfpullrequests::Application.current_year }

    it 'uses the season gift sequence instead of request timezone current date' do
      boundary_time = Time.utc(current_year, 12, 2, 0, 30, 0)
      user.update!(time_zone: 'Pacific Time (US & Canada)')

      Timecop.travel(boundary_time) do
        previous_contribution = create(:contribution, user: user, created_at: Time.utc(current_year, 12, 1, 12, 0, 0))
        target_contribution = create(:contribution, user: user, created_at: Time.utc(current_year, 12, 2, 12, 0, 0))
        user.gifts.create!(user: user, contribution: previous_contribution, date: Date.new(current_year, 12, 1))

        Time.use_zone('Pacific Time (US & Canada)') do
          gift = GiftFactory.create!(user, gift_factory, contribution_id: target_contribution.id)

          expect(gift.date).to eq(Date.new(current_year, 12, 2))
          expect(gift.date).to eq(user.ungifted_dates.first)
          expect(gift.date).to_not eq(Time.zone.now.to_date)
        end
      end
    end
  end
end
