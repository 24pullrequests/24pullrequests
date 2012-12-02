require 'spec_helper'

describe 'Projects' do
  let(:user) { create :user, email_frequency: 'daily' }
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
      fill_in 'Name', with: Faker::Lorem.words.first
      fill_in 'Github url', with: Faker::Internet.url
      fill_in 'Summary', with: Faker::Lorem.paragraphs.first
      fill_in 'Main language', with: 'Ruby'
      click_on 'Submit Project'
    end
  end
end
