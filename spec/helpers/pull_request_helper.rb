require 'rails_helper'

describe PullRequestHelper, :type => :helper do
  before do
    1.times { create :pull_request, language: "HTML" }
    2.times { create :pull_request, language: "Ruby" }
  end

  describe '#pull_request_count' do
    it 'returns the number of all pull_request' do
      expect(helper.pull_request_count).to eql(1)
    end

    it 'returns the number of all users using a language' do
      @language = "ruby"

      expect(helper.pull_request_count).to eql(2)
    end
  end
end
