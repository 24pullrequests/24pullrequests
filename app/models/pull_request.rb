class PullRequest
  attr_reader :title, :changed_files, :issue_url, :body, :state, :merged, :created_at, :repo_name

  EARLIEST_PULL_DATE = 1354320000

  def initialize(json)
    ["title", "changed_files", "issue", 'issue_url', "created_at", "state", "body", "merged"].each do |f|
      value = json["payload"]["pull_request"][f]
      instance_variable_set("@#{f}", value)
    end
    @repo_name = json['repo']['name']
  end

  private

  # Not in use, enable before go live, only provide events from dec first onward
  def self.pulled_in_december?(event)
    event_date = DateTime.parse(event['payload']['pull_request']['created_at']).strftime("%s").to_i
    event_date >= EARLIEST_PULL_DATE
  end
end