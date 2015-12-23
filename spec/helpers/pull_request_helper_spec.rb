require 'rails_helper'

describe PullRequestHelper, type: :helper do
  before do
    1.times { create :pull_request, language: 'HTML' }
    2.times { create :pull_request, language: 'Ruby' }
    4.times { create :pull_request, created_at: DateTime.now - 1.year }
  end

  describe '#pull_request_count' do
    it 'returns the number of pull requests in the current year' do
      expect(helper.pull_request_count).to eql(3)
    end

    it 'returns the number of all pull requests in a given language' do
      @language = 'ruby'

      expect(helper.pull_request_count).to eql(2)
    end
  end
end
