require 'rails_helper'
require 'rake'

describe Organisation, type: :model do

  it 'orders organisations by pull request count' do
    setup_contribution_data

    ordered_organisations = Organisation.order_by_contributions

    expect(ordered_organisations.first.contribution_count).to eq(6)
    expect(ordered_organisations.last.contribution_count).to eq(2)
  end

  def setup_contribution_data
    most_pr_user = create(:user)
    3.times { create :contribution, user: most_pr_user }

    low_pr_user = create(:user)
    1.times { create :contribution, user: low_pr_user }

    some_pr_user = create(:user)
    2.times { create :contribution, user: some_pr_user }

    create :organisation, login: 'most_low_org', users: [most_pr_user, low_pr_user]
    create :organisation, login: 'some_org', users: [some_pr_user]
    create :organisation, login: 'all_org',  users: [most_pr_user, some_pr_user, low_pr_user]
    create :organisation, login: 'most_some_org', users: [most_pr_user, some_pr_user]

    update_contribution_counts
  end

  context 'with pull request filtering' do
    let(:user) do
      user = create(:user)
      create :aggregation_filter, user: user, title_pattern: '% filtered'

      user
    end

    let!(:included_pr) do
      create(:contribution, user: user, title: 'should be included')
    end

    let!(:filtered_pr) do
      create(:contribution, user: user, title: 'should be filtered')
    end

    let!(:uppercase_filtered_pr) do
      create(:contribution, user: user, title: 'SHOULD ALSO BE FILTERED')
    end

    let(:organisation) do
      organisation = create :organisation, login: 'filtered-org', users: [user]
      update_contribution_counts
      organisation.reload
    end

    describe '.contributions' do
      subject { organisation.contributions }

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

    describe '.contributions_count' do
      subject { organisation.contribution_count }

      it 'should count only non-filtered pull requests' do
        is_expected.to eq(Contribution.all.count - 2)
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

  def update_contribution_counts
    Tfpullrequests::Application.load_tasks
    Rake::Task['users:refresh_contribution_counts'].execute
    Rake::Task['organisations:update_contribution_count'].execute
  end
end
