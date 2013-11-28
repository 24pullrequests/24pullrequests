require 'spec_helper'

describe 'Projects' do
  let(:user) { create :user }
  let!(:projects) { [ "Ruby", "Erlang"].map { |lan| create :project, main_language: lan } }
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

    it "editing a project" do
      visit edit_admin_project_path(projects.first)

      fill_in 'Name', with: 'Pugalicious'
      click_on "Update Project"

      should have_content "Project updated successfully!"
      should have_content "Pugalicious"
    end
  end
end
