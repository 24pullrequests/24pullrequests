class PullRequest
  attr_reader :title, :changed_files, :issue_url, :body, :state, :merged, :created_at
  
  EARLIEST_PULL_DATE = 1354320000
  
  def self.find_by_nickname(nickname)
    event_stream = RestClient.get "https://api.github.com/users/#{nickname}/events/public"
    events = JSON.parse(event_stream)
    events.select{|e| is_a_pull?(e) }.map {|pr| PullRequest.new(pr) }
  end
  
  def initialize(json)
    ["title", "changed_files", "issue", "created_at", "state", "body", "merged"].each do |f|
      value = json["payload"]["pull_request"][f]
      instance_variable_set("@#{f}", value)
    end
  end
  
  private
  def self.is_a_pull?(event); event['type'] == 'PullRequestEvent'; end
  
  # Not in use, enable before go live, only provide events from dec first onward
  def self.pulled_in_december?(event)
    event_date = DateTime.parse(event['payload']['pull_request']['created_at']).strftime("%s").to_i
    event_date >= EARLIEST_PULL_DATE
  end
end