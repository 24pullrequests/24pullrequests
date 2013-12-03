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
      fill_in 'Summary', :with => Faker::Lorem.paragraphs.first
      fill_in 'Main language', :with => 'Ruby'
      click_on 'Submit Project'

      click_on 'My Suggestions'
      should have_content("akira/24pullrequests")
    end
  end

  describe 'filtering the project list', :js do

    context 'as anonymous user' do
      before { visit projects_path }

      it 'should not show the filter for user languages' do
        within '#languages' do
          page.should_not have_content 'Suggested for me'
        end
      end
    end

    context 'as logged-in user' do
      before do
        create :project, name: 'Ruby project', main_language: 'Ruby'
        create :project, name: 'Java project', main_language: 'Java'
        user.skills.create! language: 'Ruby'
        login user
        visit projects_path
      end

      it 'should show a filter for user languages' do
        within '#languages' do
          page.should have_content 'Suggested for you'
        end
      end

      it 'should show both projects by default' do
        within '#projects' do
          page.should have_selector('h4', text: /Java project/i)
          page.should have_selector('h4', text: /Ruby project/i)
        end
      end

      it 'should filter projects in languages other than the selected' do
        first(:link, "Java").click

        within '#projects' do
          page.should have_no_css('.ruby')
          page.should have_css('.java')
        end
      end

      it 'should show only the Ruby project when clicking "Suggested for you"' do
        click_link 'Suggested for you'
        within '#projects' do
          page.should have_css('.ruby')
          page.should_not have_css('.java')
        end
      end

      it 'should reset an active filter when clicking "Everything"' do
        first(:link, "Ruby").click
        click_link 'Everything'
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
      it "should be able to edit projects they have suggested" do
        within('.java') { click_on "Edit" }

        fill_in 'Main language', with: 'Python'
        click_on "Submit Project"

        should have_content "Project updated successfully!"
        page.should have_css('.python')
      end

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
