require 'spec_helper'
describe Organisation do

  context "#scopes" do
    it "order_by_pull_requests" do
      setup_pull_request_data

      ordered_organisations = Organisation.order_by_pull_requests

      ordered_organisations.first.pull_request_count.should eq(6)
      ordered_organisations.last.pull_request_count.should eq(2)
    end

    it "with_pull_request_count" do
      organization = create(:organisation)

      Organisation.with_pull_request_count.find_by_login(organization.login).pull_request_count.should eq(0)
    end

  end

  def setup_pull_request_data
    most_pr_user = create(:user)
    3.times { create :pull_request, user: most_pr_user }

    low_pr_user = create(:user)
    1.times { create :pull_request, user: low_pr_user }

    some_pr_user = create(:user)
    2.times { create :pull_request, user: some_pr_user }

    create :organisation, users: [ most_pr_user, low_pr_user ]
    create :organisation, users: [ some_pr_user ]
    create :organisation, users: [ most_pr_user, some_pr_user, low_pr_user ]
    create :organisation, users: [ most_pr_user, some_pr_user ]
  end

end
