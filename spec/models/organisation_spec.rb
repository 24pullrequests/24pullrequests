require 'rails_helper'
require 'rake'

describe Organisation, type: :model do

  it 'pull_request_count' do
    setup_pull_request_data

    Tfpullrequests::Application.load_tasks
    Rake::Task['organisations:update_pull_request_count'].invoke

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

    create :organisation, login: 'pugnation', users: [most_pr_user, low_pr_user]
    create :organisation, login: '24pullrequsts', users: [some_pr_user]
    create :organisation, login: 'kobol',  users: [most_pr_user, some_pr_user, low_pr_user]
    create :organisation, login: 'caprica', users: [most_pr_user, some_pr_user]
  end
end
