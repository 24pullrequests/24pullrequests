require 'rails_helper'

describe CountHelper, type: :helper do
  context 'with language present' do
    before do
      @language = 'Erlang'
    end

    describe '#project_count_for_language' do
      it 'returns the number of project using the given language' do
        3.times { create :project, main_language: @language }
        2.times { create :project, inactive: true, main_language: @language }

        expect(helper.project_count_for_language).to eql(3)
      end
    end

    describe '#pull_request_count_for_language' do
      it 'returns the number of pull requests using the given language' do
        5.times { create :pull_request, language: 'Erlang' }
        3.times { create :pull_request, language: 'Erlang', created_at: Time.zone.today - 1.year }

        expect(helper.pull_request_count_for_language).to eql(5)
      end
    end

    describe '#user_count_for_language' do
      it 'returns the number of users using the given language' do
        2.times { create :skill, language: @language }

        expect(helper.user_count_for_language).to eql(2)
      end
    end
  end

  describe '#pull_request_count' do
    before do
      1.times { create :pull_request, language: 'HTML' }
      2.times { create :pull_request, language: 'Ruby' }
      4.times { create :pull_request, created_at: DateTime.now - 1.year }
    end

    it 'returns the number of pull requests in the current year' do
      expect(helper.pull_request_count).to eql(3)
    end

    it 'returns the number of all pull requests in a given language' do
      @language = 'ruby'

      expect(helper.pull_request_count).to eql(2)
    end
  end

  describe "#user_count" do
    before do
      3.times { create :skill, language: 'Erlang' }
      2.times { create :skill, language: 'Python' }
    end

    describe '#user_count' do
      it 'returns the number of all users' do
        expect(helper.user_count).to eql(5)
      end

      it 'returns the number of all users using a language' do
        @language = 'Python'

        expect(helper.user_count).to eql(2)
      end
    end
  end
end
