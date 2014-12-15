require 'rails_helper'

describe PullRequestsDecorator do

  before do
    100.times do
      FactoryGirl.create :pull_request, body: 'happy 24 pull requests!'
    end
  end

  subject { PullRequestsDecorator.new(PullRequest.all) }

  describe '#attributes' do

    it 'gives me the correct count' do
      expect(subject.attributes[:count]).to eq(100)
    end

    it 'gives me the correct page count' do
      expect(subject.attributes[:total_pages]).to eq(4)
    end

    it 'gives me only the keys I want' do
      expect(subject.attributes.keys).to eq([:count, :total_pages])
    end

  end

end
