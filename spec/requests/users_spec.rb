require 'spec_helper'

describe 'Users' do
  subject { page }
  let(:user) { create :user, nickname: "akira" }

  describe 'viewing the list of users' do
    before do
      5.times { create :user }
      visit users_path
    end

    it { should have_content '5 Developers already involved'}
  end

  describe "authenticated user navigation" do
    let!(:pull_requests) { 2.times.map { create :pull_request, user: user } }

    before do
      login(user)
    end

    it "#profile" do
      click_on 'Profile'

      should have_content "akira has made 2 total pull requests so far in #{Time.now.year}"
    end

    context "#my_suggestions" do

      it "when there are none" do
        click_on 'My Suggestions'

        should have_content "You haven't suggested any projects yet."
      end

      it "when the user has suggested projects" do
        projects  = 3.times.map { create :project, submitted_by: user }

        click_on 'My Suggestions'

        projects.each do |project|
          should have_content project.github_repository
          should have_content project.description
        end
      end

      context "claiming projects" do
        it "without an owner" do
          create :project, github_url: "http://github.com/andrew/24pullrequests", submitted_by: nil

          visit my_suggestions_path
          fill_in "project_github_url", with: "andrew/24pullrequests"
          click_on "Claim"

          should have_content "You have successfully claimed andrew/24pullrequests"
        end

        it "with an owner" do
          create :project, github_url: "http://github.com/santa/raindeers"

          visit my_suggestions_path
          fill_in "project_github_url", with: "santa/raindeers"
          click_on "Claim"

          should have_content "This repository doesn't exist or belongs to someone else"
        end
      end
    end
  end
end
