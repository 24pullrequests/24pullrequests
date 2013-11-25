require 'spec_helper'

describe 'LanguageRequests' do
  subject { page }

  describe 'viewing information by language' do
    before do
      6.times { create :project, main_language: "Haskell" }
      3.times { create :skill, language: 'Haskell' }
      9.times { create :pull_request, language: "Haskell" }

      visit language_path("haskell")
    end

    it { should have_content '3 Developers'}
    it { should have_content '6 Suggested projects'}
    it { should have_content 'Latest 5 Pull Requests (9 total)'}
  end
end
