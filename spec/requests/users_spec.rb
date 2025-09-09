require 'rails_helper'

describe 'Users', type: :request do
  subject { page }
  let(:user) { create :user, nickname: 'akira' }

  before do
    mock_is_admin
  end

  describe 'viewing the list of users' do
    before do
      5.times { create :user }
      visit users_path
    end

    it { is_expected.to have_content '5 Contributors already involved' }
  end

  describe 'authenticated user navigation' do
    before do
      login(user)
    end

    describe '#profile' do

      describe 'when the user has not issued any pull requests' do
        it 'should display the grinchy message' do
          click_on 'Profile'

          is_expected.to have_content "akira has gifted no contributions this year."
        end
      end

      describe 'when the user has gifted code or issued pull requests' do
        let!(:contributions) do
          [
            create(:contribution, user: user, repo_name: 'foo/bar', title: "Moar foos"),
            create(:contribution, user: user, repo_name: 'baz/qux', title: "Hi baz")
          ]
        end
        let!(:gift) { create(:gift, user: user, contribution: contributions.first) }

        it 'has pull requests' do
          click_on 'Profile'

          is_expected.to have_content 'akira has made 2 contributions ' \
          "so far during the #{Time.zone.now.year} holidays"

          is_expected.to have_link gift.contribution.title

          click_on 'Contributions'
          is_expected.to have_content contributions.last.title
        end

        context 'with ignored organisations' do
          before { user.update_column(:ignored_organisations, %w{foo}) }

          it 'filters out repos for ignored organisations but still allows gifts' do
            click_on 'Profile'

            is_expected.to have_content 'akira has made 1 contribution ' \
              "so far during the #{Time.zone.now.year} holidays"

            is_expected.to have_link "Moar foos"
            is_expected.to have_link "Hi baz"

            click_on 'Contributions'
            is_expected.to_not have_link "foo/bar"
            is_expected.to have_link "baz/qux"
          end
        end
      end

      describe 'when the user belong to an organisation' do
        let!(:organisation) { create(:organisation)  }
        let!(:user) { create(:user) }

        before do
          organisation.users << user
        end

        it 'has organisations' do
          visit user_path(user)

          is_expected.to have_content('Member of...')
        end
      end
    end

    context '#my_suggestions' do

      it 'when there are none' do
        click_on 'My Suggestions'

        is_expected.to have_content "You haven’t suggested any projects yet."
      end

      it 'when the user has suggested projects' do
        projects  = 3.times.map { create :project, submitted_by: user }

        click_on 'My Suggestions'

        projects.each do |project|
          is_expected.to have_content project.github_repository
          is_expected.to have_content project.description
        end
      end

      context 'claiming projects' do
        it 'without an owner' do
          create :project, github_url: 'http://github.com/24pullrequests/24pullrequests', submitted_by: nil

          visit my_suggestions_path
          fill_in 'project_github_url', with: '24pullrequests/24pullrequests'
          click_on 'Claim'

          is_expected.to have_content 'You have successfully claimed 24pullrequests/24pullrequests'
        end

        it 'with an owner' do
          create :project, github_url: 'http://github.com/santa/raindeers'

          visit my_suggestions_path
          fill_in 'project_github_url', with: 'santa/raindeers'
          click_on 'Claim'

          is_expected.to have_content "This repository doesn't exist or belongs to someone else"
        end
      end
    end
  end
end
