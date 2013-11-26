require 'spec_helper'

describe PullRequestHelper do
  before do
    1.times { create :pull_request, language: "HTML" }
    2.times { create :pull_request, language: "Ruby" }
  end

  describe '#pull_request_count' do
    it 'returns the number of all pull_request' do
      helper.pull_request_count.should eql(1)
    end

    it 'returns the number of all users using a language' do
      @language = "ruby"

      helper.pull_request_count.should eql(2)
    end
  end
end
