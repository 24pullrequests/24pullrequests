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
    it { should have_content '6 Projects'}
    it { should have_content 'Latest 5 Pull Requests (9 total)'}

    describe "view all" do
      it "#projects" do
        within("#projects") { click_on "View All" }

        should have_content "6 Projects are using Haskell"
      end

      it "#users" do
        within("#users") { click_on "View All" }

        should have_content "3 Developers using Haskell are involved"
      end
    end
  end

  describe "viewing a non existing language" do

    it "should raise an error" do
      expect { visit language_path("Pugs") }.
        to raise_error(ActionController::RoutingError, "Pugs is not a valid language")
    end
  end
end
