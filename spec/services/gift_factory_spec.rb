require 'rails_helper'

describe GiftFactory do
  let(:user) { FactoryGirl.create(:user) }
  let(:pull_request) { FactoryGirl.create(:pull_request) }
  let(:gift_factory) { Gift.public_method(:new) }

  describe "#create!" do
    it "generates a new gift for the user" do
      gift = GiftFactory.create!(user, gift_factory, pull_request_id: pull_request.id)
      expect(gift.pull_request).to eq(pull_request)
    end
  end

  describe '#create_from_attrs' do
    it 'creates a new present' do
      factory = GiftFactory.new(user, gift_factory)
      gift = factory.create_from_attrs({})

      expect(gift.date).to eq(PullRequest::EARLIEST_PULL_DATE)
    end
  end

  context "when the user has gifted some PRs" do
    describe "#create_from_attrs" do
      before do
        user.gifts.create!({
          user: user,
          pull_request: pull_request,
          date: Date.new(CURRENT_YEAR, 12, 5)
        })
      end

      it "creates a new present" do
        factory = GiftFactory.new(user, gift_factory)
        gift = factory.create_from_attrs({})

        expect(gift.date).to eq(PullRequest::EARLIEST_PULL_DATE)
      end
    end
  end
end
