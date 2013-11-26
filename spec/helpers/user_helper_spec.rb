require 'spec_helper'

describe UserHelper do
  before do
    3.times { create :skill, language: "Erlang" }
    2.times { create :skill, language: "Python" }
  end

  describe '#user_count' do
    it 'returns the number of all users' do
      helper.user_count.should eql(5)
    end

    it 'returns the number of all users using a language' do
      @language = "Python"

      helper.user_count.should eql(2)
    end
  end
end
