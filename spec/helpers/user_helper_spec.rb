require 'spec_helper'

describe UserHelper, :type => :helper do
  before do
    3.times { create :skill, language: "Erlang" }
    2.times { create :skill, language: "Python" }
  end

  describe '#user_count' do
    it 'returns the number of all users' do
      expect(helper.user_count).to eql(5)
    end

    it 'returns the number of all users using a language' do
      @language = "Python"

      expect(helper.user_count).to eql(2)
    end
  end
end
