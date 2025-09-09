require 'rails_helper'

describe 'LanguagesRequests', type: :request do
  subject { page }

  describe 'viewing information by language' do

    before do
      6.times { create :project, main_language: 'Haskell' }
      1.times { create :project, inactive: true, main_language: 'Haskell' }
      3.times { create :skill, language: 'Haskell' }
      9.times { create :contribution, language: 'Haskell' }

      visit language_path('haskell')
    end

    it { is_expected.to have_content '3 Contributors' }
    it { is_expected.to have_content '6 Haskell Projects' }
    it { is_expected.to have_content 'Latest Haskell Contributions (9 total)' }

    describe 'view all' do
      it '#projects' do
        within('#projects') { click_on 'View All' }

        is_expected.to have_content '6 Projects are using Haskell'
      end

      it '#users' do
        within('#users') { click_on 'View All' }

        is_expected.to have_content '3 Contributors using Haskell'
      end

      it '#contributions' do
        within('#contributions') { click_on 'View All' }

        is_expected.to have_content '9 contributions already made in Haskell!'
      end
    end
  end

  describe 'viewing a non existing language' do

    it 'should show a 404 error' do
      visit language_path('Pugs')
      expect(page.status_code).to eq(404)
    end
  end
end
