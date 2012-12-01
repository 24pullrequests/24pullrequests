require 'spec_helper'

describe 'Projects' do
  let(:user) { create :user, email_frequency: 'daily' }
  subject { page }

  describe 'suggesting a new project' do
    before do
      login user
      visit dashboard_path
    end

    it 'allows the user to suggest a project to contribute to' do
      click_link 'Suggest a project'
      fill_in 'Name', with: Faker::Lorem.words.first
      fill_in 'Github url', with: Faker::Internet.url
      fill_in 'Summary', with: Faker::Lorem.paragraphs.first
      fill_in 'Main language', with: 'Ruby'
      click_on 'Submit Project'
    end
  end

  describe 'filtering the project list' do

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
        create :project, name: 'Ruby project', main_language: 'ruby'
        create :project, name: 'Java project', main_language: 'java'
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
          page.should have_content 'Ruby project'
          page.should have_content 'Java project'
        end
      end

      it 'should filter projects in languages other than the selected' do
        click_link 'ruby'
        within '#projects' do
          page.should have_css('.ruby', visible: true)
          page.should have_css('.java', visible: false)
        end
      end

      it 'should show only the Ruby project when clicking "Suggested for you"' do
        click_link 'Suggested for you'
        within '#projects' do
          page.should have_css('.ruby', visible: true)
          page.should have_css('.java', visible: false)
        end
      end

      it 'should reset an active filter when clicking "Everything"' do
        click_link 'ruby'
        click_link 'Everything'
        within '#projects' do
          page.should have_css('.ruby', visible: true)
          page.should have_css('.java', visible: true)
        end
      end

    end
  end
end
