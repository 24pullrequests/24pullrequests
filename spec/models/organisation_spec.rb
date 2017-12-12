require 'rails_helper'
require 'rake'

describe Organisation, type: :model do

  it 'orders organisations by pull request count' do
    setup_pull_request_data

    ordered_organisations = Organisation.order_by_pull_requests

    expect(ordered_organisations.first.pull_request_count).to eq(6)
    expect(ordered_organisations.last.pull_request_count).to eq(2)
  end

  def setup_pull_request_data
    most_pr_user = create(:user)
    3.times { create :pull_request, user: most_pr_user }

    low_pr_user = create(:user)
    1.times { create :pull_request, user: low_pr_user }

    some_pr_user = create(:user)
    2.times { create :pull_request, user: some_pr_user }

    create :organisation, login: 'most_low_org', users: [most_pr_user, low_pr_user]
    create :organisation, login: 'some_org', users: [some_pr_user]
    create :organisation, login: 'all_org',  users: [most_pr_user, some_pr_user, low_pr_user]
    create :organisation, login: 'most_some_org', users: [most_pr_user, some_pr_user]

    update_pull_request_counts
  end

  context 'with pull request filtering' do
    let(:user) do
      user = create(:user)
      create :aggregation_filter, user: user, title_pattern: '% filtered'

      user
    end

    let!(:included_pr) do
      create(:pull_request, user: user, title: 'should be included')
    end

    let!(:filtered_pr) do
      create(:pull_request, user: user, title: 'should be filtered')
    end

    let!(:uppercase_filtered_pr) do
      create(:pull_request, user: user, title: 'SHOULD ALSO BE FILTERED')
    end

    let(:organisation) do
      organisation = create :organisation, login: 'filtered-org', users: [user]
      update_pull_request_counts
      organisation.reload
    end

    describe '.pull_requests' do
      subject { organisation.pull_requests }

      it 'should include only non-filtered pull requests' do
        is_expected.to include included_pr
        is_expected.not_to include filtered_pr
      end

      it 'should not be case sensitive when filtering pull requests' do
        is_expected.to include included_pr
        is_expected.not_to include filtered_pr
        is_expected.not_to include uppercase_filtered_pr
      end
    end

    describe '.pull_requests_count' do
      subject { organisation.pull_request_count }

      it 'should count only non-filtered pull requests' do
        is_expected.to eq(PullRequest.all.count - 2)
      end
    end
  end


  describe '#find_by_login' do
    let!(:organisation) { create(:organisation, login: 'TestOrg') }

    context 'with valid login' do
      it 'finds organization if capitalization same' do
        expect(Organisation.find_by_login!('TestOrg')).to eq organisation
      end

      it 'finds organization if capitalization differs' do
        expect(Organisation.find_by_login!('TESTorg')).to eq organisation
      end
    end

    context 'with invalid login' do
      it 'does not find an organization' do
        expect { Organisation.find_by_login!('fooOrg') }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  def update_pull_request_counts
    Tfpullrequests::Application.load_tasks
    Rake::Task['refresh_pull_request_counts'].execute
    Rake::Task['organisations:update_pull_request_count'].execute
  end
end
