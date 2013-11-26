require 'spec_helper'

describe LanguageHelper do
  before do
    @language = "Erlang"
  end

  describe '#pull_request_count_for_language' do
    it 'returns the number of pull requests using the given language' do
      5.times { create :pull_request, language: "Erlang" }

      helper.pull_request_count_for_language.should eql(5)
    end
  end

  describe '#user_count_for_language' do
    it 'returns the number of users using the given language' do
      2.times { create :skill, language: @language }

      helper.user_count_for_language.should eql(2)
    end
  end
end
