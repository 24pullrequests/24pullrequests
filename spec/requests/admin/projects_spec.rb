require 'spec_helper'

describe 'Projects' do
  let(:user) { create :user }
  let!(:projects) { [ "repo1", "repo2"].map { |repo| create :project, github_url: "http://github.com/christmas/#{repo}" } }
  subject { page }

  before do
    user.stub(:is_collaborator? => true)
    login(user)

    visit admin_projects_path
  end

  describe 'project index' do

    it "should list all projects" do
      projects.each do |project|
        should have_content project.name
      end
    end
  end

  describe 'managing projects', js: true do

    before do
      fill_in "_repository", with: "repo1"
      click_on "Search"
    end

    it "search for a project" do
      should_not have_content "repo2"
      should have_content "repo1"
    end

    it "editing a project" do
      click_on "Edit"

      fill_in 'Name', with: 'Pugalicious'
      click_on "Update Project"

      should have_content "Project updated successfully!"

      puts page.text
      should have_content "PUGALICIOUS"
    end
  end
end
