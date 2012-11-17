class PullRequest
  attr_reader :title, :changed_files, :issue_url, :body, :state, :merged, :created_at
  
  EARLIEST_PULL_DATE = 1354320000
  
  def self.find_by_nickname(nickname)
    @nickname = nickname
    parse_events(get_event_pages(10))
  end
  
  def initialize(json)
    ["title", "changed_files", "issue", 'issue_url', "created_at", "state", "body", "merged"].each do |f|
      value = json["payload"]["pull_request"][f]
      instance_variable_set("@#{f}", value)
    end
  end
  

  private
  
  def self.get_event_pages(count = 5)
    hydra = Typhoeus::Hydra.new
    requests = (1..count).map {|i| Typhoeus::Request.new( "https://api.github.com/users/#{@nickname}/events/public?page=#{i}" ) }
    requests.each {|r| hydra.queue(r) }
    hydra.run
    
    requests.map {|r| r.response.body }
  end
  
  def self.parse_events(event_pages)
    events = event_pages.inject([]) {|col, ep| col.concat( JSON.parse(ep) ); col }
    events.select{|e| is_a_pull?(e) && pulled_by_user?(e) }.map {|pr| PullRequest.new(pr) }
  end
  
  def self.is_a_pull?(event)
    # No user object looks like an old style pull request/issue
    event['type'] == 'PullRequestEvent' && !event['payload']['pull_request']['user'].nil?
  end
  
  def self.pulled_by_user?(event)
    event['payload']['pull_request']['user']['login'] == @nickname
  end
  
  # Not in use, enable before go live, only provide events from dec first onward
  def self.pulled_in_december?(event)
    event_date = DateTime.parse(event['payload']['pull_request']['created_at']).strftime("%s").to_i
    event_date >= EARLIEST_PULL_DATE
  end
end