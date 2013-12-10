require 'spec_helper'

describe 'Projects' do
  let(:user) { create :user, :email_frequency => 'daily' }
  subject { page }

  describe 'project index' do
    before do
      2.times { create :project }
      visit projects_path
    end

    it { should have_content '2 Suggested Projects' }
  end

  describe 'suggesting a new project' do
    before do
      login user
      visit dashboard_path
    end

    it 'allows the user to suggest a project to contribute to' do
      click_link 'Suggest a project'
      fill_in 'Name', :with => Faker::Lorem.words.first
      fill_in 'Github url', :with => 'http://github.com/akira/24pullrequests'
      fill_in 'Summary', :with => Faker::Lorem.paragraphs.first[0..199]
      fill_in 'Main language', :with => 'Ruby'
      click_on 'Submit Project'

      click_on 'My Suggestions'
      should have_content("akira/24pullrequests")
    end
  end

  describe 'filtering the project list', :js do

    context 'as logged-in user' do
      before do
        create :project, name: 'Ruby project', main_language: 'Ruby'
        create :project, name: 'Java project', main_language: 'Java'
        user.skills.create! language: 'Ruby'
        login user
        visit projects_path
      end

      it 'should show projects with the users languages by default' do
        within '#projects' do
          page.should have_selector('h4', text: /Ruby project/i)
        end
      end

      it 'should display projects for any selected languages' do
        all('.icheckbox_line', text: "Java").first.click

        within '#projects' do
          page.should have_css('.ruby')
          page.should have_css('.java')
        end
      end

      it 'should reset active filter when clicking "All Languages"' do
        all('.icheckbox_line', text: "All Languages").first.click
        within '#projects' do
          page.should have_css('.ruby')
          page.should have_css('.java')
        end
      end
    end
  end

  describe 'editing suggested projects' do

    let!(:user_project) { create :project, name: 'Java project', main_language: 'Java', submitted_by: user }
    let!(:other_project) { create :project, name: 'Ruby project', main_language: 'Ruby' }

    before do
      login user
      visit my_suggestions_path
    end

    context 'a logged-in user' do
      # it "should be able to edit projects they have suggested" do
      #   within('.java') { click_on "Edit" }

      #   fill_in 'Main language', with: 'Python'
      #   click_on "Submit Project"

      #   should have_content "Project updated successfully!"
      #   page.should have_css('.python')
      # end

      it "can deactive a project" do
        first(:link, "Deactive").click

        should have_content "#{user_project.name} has been deactivated."
      end
    end

    it "should not be able to edit other user's suggestions" do
      visit edit_project_path(other_project)

      should have_content "You can only edit projects you have suggested!"
    end
  end
end
