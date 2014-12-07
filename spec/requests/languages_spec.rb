require 'rails_helper'

describe 'LanguagesRequests', type: :request do
  subject { page }

  describe 'viewing information by language' do

    before do
      6.times { create :project, main_language: 'Haskell' }
      1.times { create :project, inactive: true, main_language: 'Haskell' }
      3.times { create :skill, language: 'Haskell' }
      9.times { create :pull_request, language: 'Haskell' }

      visit language_path('haskell')
    end

    it { is_expected.to have_content '3 Developers' }
    it { is_expected.to have_content '6 Haskell Projects' }
    it { is_expected.to have_content 'Latest Haskell Pull Requests (9 total)' }

    describe 'view all' do
      it '#projects' do
        within('#projects') { click_on 'View All' }

        is_expected.to have_content '6 Projects are using Haskell'
      end

      it '#users' do
        within('#users') { click_on 'View All' }

        is_expected.to have_content '3 Developers using Haskell'
      end

      it '#pull_requests' do
        within('#pull_requests') { click_on 'View All' }

        is_expected.to have_content '9 pull requests already made in Haskell!'
      end
    end
  end

  describe 'viewing a non existing language' do

    it 'should raise an error' do
      expect { visit language_path('Pugs') }
        .to raise_error(ActionController::RoutingError, 'Pugs is not a valid language')
    end
  end
end
