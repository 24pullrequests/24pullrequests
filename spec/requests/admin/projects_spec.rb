require 'spec_helper'

describe 'Admin Projects' do
  let(:user) { create :user }
  let!(:projects) { ["apples", "mandarins"].map { |repo| create :project, name: repo, github_url: "http://github.com/christmas/#{repo}" } }
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

  describe 'managing projects' do
    it "search for a project", js: true do
      fill_in "_repository", with: "apples"
      click_on "Search"

      sleep(Capybara.default_wait_time)

      should have_content "apples"
      should_not have_content "mandarins"
    end

    it "editing a project", js: true do
      first(:link, "Edit").click

      fill_in 'Name', with: 'Pugalicious'
      click_on "Update Project"

      should have_content "Project updated successfully!"

      should have_content "PUGALICIOUS"
    end

    it "deactives a project" do
      first(:link, "Deactive").click

      should have_content "#{projects.first.name} has been deactivated."
    end
  end
end
