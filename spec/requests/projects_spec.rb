require 'rails_helper'

describe 'Projects', type: :request do
  let(:user) { create :user, email_frequency: 'daily' }
  subject { page }

  before do
    mock_is_admin
  end

  describe 'project index' do
    before do
      2.times { create :project }
      visit projects_path
    end

    it { is_expected.to have_content '2 Suggested Projects' }
  end

  describe 'project show' do
    let(:project) { create :project, name: 'octocat/hello', github_url: 'https://github.com/octocat/hello', contribulator: 17 }

    it 'is visible to logged out visitors and shows the project details' do
      visit project_path(project)
      is_expected.to have_content 'octocat/hello'
      is_expected.to have_content project.description
      is_expected.to have_content 'Contribulator score: 17'
      is_expected.to have_link 'View on GitHub', href: 'https://github.com/octocat/hello'
    end

    it 'lists the contributors and pull requests made to the project' do
      contributor = create :user
      create :contribution, user: contributor, repo_name: 'octocat/hello', title: 'Fix the typo'
      create :contribution, repo_name: 'someone/else', title: 'Unrelated change'
      visit project_path(project)
      is_expected.to have_content 'Pull requests (1)'
      is_expected.to have_link 'Fix the typo'
      is_expected.to have_link href: user_path(contributor.nickname)
      is_expected.to_not have_content 'Unrelated change'
    end

    it 'explains when there are no contributions yet' do
      visit project_path(project)
      is_expected.to have_content I18n.t('projects.show.no_pull_requests')
    end

    it 'is linked to from the project index' do
      project
      visit projects_path
      click_link I18n.t('projects.show.details')
      expect(page).to have_current_path(project_path(project))
    end
  end
  describe 'suggesting a new project' do
    before do
      login user
      visit dashboard_path
    end

    it 'allows the user to suggest a project to contribute to' do
      client = double(:github_client)
      expect(GithubClient).to receive(:new).twice.with(user.nickname, user.token).and_return(client)
      expect(client).to receive(:repository).with("akira/24pullrequests")
      expect(client).to receive(:community_profile)

      click_link 'Suggest a project'
      fill_in 'Name', with: Faker::Lorem.words.first
      fill_in 'GitHub URL', with: 'http://github.com/akira/24pullrequests'
      fill_in 'Summary', with: Faker::Lorem.paragraphs.first[0..199]
      find(:css, '#project_main_language').find(:option, 'Ruby').select_option
      click_on 'Submit Project'

      click_on 'My Suggestions'
      is_expected.to have_content('akira/24pullrequests')
    end

    it 'rejects a javascript homepage' do
      client = double(:github_client, repository: nil, community_profile: nil)
      allow(GithubClient).to receive(:new).and_return(client)

      page.driver.submit :post, projects_path, project: {
        name: 'akira/24pullrequests',
        github_url: 'http://github.com/akira/24pullrequests',
        description: Faker::Lorem.paragraphs.first[0..199],
        main_language: 'Ruby',
        homepage: 'javascript:alert(1)'
      }

      expect(Project.count).to eq(0)
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
          expect(page).to have_selector('.project-title', text: /Ruby project/i)
        end
      end

      it 'should display projects for any selected languages' do
        all('.icheckbox_line', text: 'Java').first.click

        within '#projects' do
          expect(page).to have_css('.ruby')
          expect(page).to have_css('.java')
        end
      end

      it 'should reset active filter when clicking "All Languages"' do
        all('.icheckbox_line', text: 'All Languages').first.click
        within '#projects' do
          expect(page).to have_css('.ruby')
          expect(page).to have_css('.java')
        end
      end

      # it 'should retain selected filters when requesting more pages' do
      #   pending 'This test is flaky'
      #   30.times do |i|
      #     create :project, name: "Ruby project #{i}", main_language: 'Ruby'
      #   end
      #   Project.count
      #   visit projects_path

      #   click_on 'More'
      #   all('#projects project').each { |project| expect(project) .to have_css('ruby') }
      # end
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
      it 'should be able to edit projects they have suggested' do
        within('.java') { click_on 'Edit' }

        find(:css, '#project_main_language').find(:option, 'Python').select_option
        click_on 'Submit Project'

        should have_content 'Project updated successfully!'
        expect(page).to have_css('.python')
      end

      it 'can deactivate a project' do
        first(:link, 'Deactivate').click

        is_expected.to have_content "#{user_project.name} has been deactivated."
      end

      it 'can delete a project' do
        first(:link, 'Deactivate').click
        is_expected.to have_content "#{user_project.name} has been deactivated."

        first(:link, 'Delete').click
        is_expected.to have_content "#{user_project.name} has been deleted."
      end
    end

    it "should not be able to edit other user's suggestions" do
      visit edit_project_path(other_project)

      is_expected.to have_content 'You can only edit projects you have suggested!'
    end
  end
end
