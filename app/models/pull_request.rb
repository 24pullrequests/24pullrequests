class PullRequest  < ActiveRecord::Base
  attr_accessible :title, :issue_url, :body, :state, :merged, :created_at, :repo_name

  EARLIEST_PULL_DATE = 1354320000

  def self.initialize_from_github(json)
    {
      :title          => json["payload"]["pull_request"]['title'],
      :issue_url      => json["payload"]["pull_request"]['issue_url'],
      :created_at     => json["payload"]["pull_request"]['created_at'],
      :state          => json["payload"]["pull_request"]['state'],
      :body           => json["payload"]["pull_request"]['body'],
      :merged         => json["payload"]["pull_request"]['merged'],
      :repo_name      => json['repo']['name']
    }
  end

  private

  # Not in use, enable before go live, only provide events from dec first onward
  def self.pulled_in_december?(event)
    event_date = DateTime.parse(event['payload']['pull_request']['created_at']).strftime("%s").to_i
    event_date >= EARLIEST_PULL_DATE
  end
end