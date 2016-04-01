require 'spec_helper'

class Settings
  class << self
    def gitlab_server; 'https://gitlab.com'; end
    
    def gitlab_private_token
      @@gitlab_private_token ||= ENV.fetch "GITLAB_PRIVATE_TOKEN", File.read("#{ENV['HOME']}/.gitlab")
    end

    def log; loud? ? ->(msg){ puts msg } : ->(_) { }; end
    def loud?; ENV.include? "LOUD"; end
  end
end

class Parallel
  require 'celluloid/current'
  Celluloid.logger = Object.new

  class << self
    def each(items=[], &block)
      fail "You need to supply a block to run in parallel" unless block_given?

      items.map do |item|
        Celluloid::Future.new do
          block.call(item)
        end
      end.map{|future| future.value}.flatten
    end

    def times(count, &block)
      count.times.map do
        Celluloid::Future.new(&block)
      end.each{|future| future.value}
    end
  end
end

# API:          https://github.com/gitlabhq/gitlabhq/tree/master/doc/api
# Private keys: https://gitlab.com/profile/account (see: https://www.safaribooksonline.com/library/view/gitlab-cookbook/9781783986842/ch06s05.html)
class GitlabClient 
  require 'json'
  
  def initialize(server, token, opts={})
    @log = opts[:log] || ->(msg) {}
    @server = server
    @token = token
  end

  def user_merge_requests
    projects.map do |project|
      forked_from_id = project['forked_from_project']['id']
      
      JSON.parse exec(uri: "/api/v3/projects/#{forked_from_id}/merge_requests", query: {state: 'merged'})
    end
  end

  def closed_merge_requests(opts={})
    merge_requests({ state: 'closed', order_by: 'updated_at', sort: 'desc' }.merge(opts))
  end
  
  def merge_requests(opts={}) # http://doc.gitlab.com/ce/api/merge_requests.html
    with_defaults opts do |args|
      JSON.parse(exec(uri: "/api/v3/projects/#{opts[:project]}/merge_requests", query: args)).select do |r|
        updated_at = Time.parse(r['updated_at'])
      
        (opts[:user].nil? || r['author']['username'] == opts[:user]) &&
          (opts[:since].nil? || updated_at >= opts[:since]) &&
          (opts[:until].nil? || updated_at <= opts[:until])  
      end
    end
  end

  def merge_request_pages(opts={}) # http://doc.gitlab.com/ce/api/merge_requests.html
    with_defaults opts do |args|
      reply = exec(verb: :head, uri: "/api/v3/projects/#{opts[:project]}/merge_requests", query: args)

      link_pattern =->(label) { /<([^>]+)>; rel="#{label}"/ }

      last = reply.headers[:link].match(link_pattern.call('last'))[1]
    
      {
        first:  reply.headers[:link].match(link_pattern.call('first'))[1],
        next: reply.headers[:link].match(link_pattern.call('next'))[1],
        last: last,
        total_page_count: last.match(/page=(\d+)/)[1].to_i,
        per_page: last.match(/per_page=(\d+)/)[1].to_i,
      }
    end
  end
  
  def project(id)
    JSON.parse exec(uri: "/api/v3/projects/#{id}")
  end
  
  def projects
    JSON.parse exec(uri: '/api/v3/projects')
  end

  def user_events
    # [i] Can get project events though
    fail <<-ERR
    There is no event endpoint: <http://feedback.gitlab.com/forums/176466-general/suggestions/4035146-add-an-activity-stream-to-the-api>. 
    The atom feed is an option <https://gitlab.com/dashboard/projects.atom?private_token=xxx>", but what it shows depends on what buttons you have depressed at <https://gitlab.com/dashboard/activity>
    ERR

    JSON.parse exec('/api/v3/activity')
  end
  
  private

  def with_defaults(opts={}, &block)
    return unless block_given?

    @log.call opts
    
    state    = opts[:state]    || 'all'
    sort     = opts[:sort]     || 'desc'
    order_by = opts[:order_by] || nil
    page     = opts[:page]     || 1
    per_page = opts[:per_page] || 100

    block.call ({state: state, sort: sort, order_by: order_by, page: page, per_page: per_page})
  end
  
  def exec(opts={})
    require 'rest-client'

    query = (opts[:query] || {}).merge(private_token: @token).map{|k,v| "#{k}=#{v}"}.join('&')

    full_uri = "#{@server}/#{opts[:uri]}?#{query}".strip
    verb = opts[:verb] || :get
    
    @log.call "[T #{Thread.current.object_id}] Requesting <#{verb}> to <#{full_uri}>"
    
    RestClient::Request.execute(
      method: verb,
      url: full_uri,
      timeout: 10)
  end
end

describe 'Reading from gitlab' do
  let(:client) { GitlabClient.new Settings.gitlab_server, Settings.gitlab_private_token, {log: Settings.log} }

  it "can read other people's projects, for example <https://gitlab.com/gitlab-org/gitlab-ce>" do
    expect( client.project(13083)['description'] ).to match /version control on your server/i
  end

  it "and ask for merge requests for other people's projects" do
    expect( client.merge_requests(project: 13083).count ).to be > 0
  end

  it 'can find closed merge requests for a user' do # https://gitlab.com/gitlab-org/gitlab-ce/merge_requests?assignee_id=&author_id=&label_name=&milestone_id=&scope=all&sort=created_asc&state=closed
    expect( client.closed_merge_requests(
            project: 13083,
            user: 'razer6',
            sort: 'asc',
            order_by: 'created_at').first['title'] ).to eql("Fix Links To Gitlab Cloud")
  end

  it 'can find the closed merge requests for a project between two dates, for example December 2015' do
    first_of_december_utc = Time.new(2015,12,1,"UTC")
    thirty_first_of_december_utc = Time.new(2015,12,31,"UTC")
    
    closed_in_december = client.closed_merge_requests(
      project: 13083,
      since: first_of_december_utc,
      until: thirty_first_of_december_utc)

    expect( closed_in_december ).to all(satisfy do |r|
      actual = Time.parse(r["updated_at"])
      actual >= first_of_december_utc && actual <= thirty_first_of_december_utc
    end)
  end

  it 'can read projects, bur only for the authenticated user' do
    expect { client.projects }.to_not raise_error
  end

  it "can read the merge requests by the current user" do
    expect { client.user_merge_requests }.to_not raise_error
  end

  it 'merge requests look like this' do
    Settings.log.call JSON.pretty_generate(client.closed_merge_requests(project: 13083).first) 
  end
end

describe 'Gitlab and paging' do
  let(:client) { GitlabClient.new Settings.gitlab_server, Settings.gitlab_private_token, {log: Settings.log} }
  
  it 'can be asked to list paging information' do
    pages = client.merge_request_pages(project: 13083)

    expect( pages ).to include(:first, :next, :last, :total_page_count, :per_page)
  end

  it "can be used to fetch multiple pages in parallel" do
    paging = client.merge_request_pages(project: 13083, per_page: 100)

    how_many_pages = paging[:total_page_count] 
    
    result = Parallel.each(1..how_many_pages) do |i|
      client.merge_requests(project: 13083, page: i, per_page: paging[:per_page])
    end

    expect( result.size ).to be_within(paging[:per_page]).of(paging[:per_page] * how_many_pages)
  end
end
