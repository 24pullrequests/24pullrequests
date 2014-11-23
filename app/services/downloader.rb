class Downloader
  def initialize(user, access_token=user.token)
    @access_token = access_token
    @user = user
  end

  def get_organisations
    previous_orgs = user.organisations.all
    current_orgs = user_downloader.user_organisations

    current_orgs.map! do |org|
      organisation = Organisation.create_from_github(org)

      organisation.users << user unless organisation.users.include?(user)
      organisation.save
      organisation
    end
    (previous_orgs - current_orgs).each do |org|
      user.organisations.delete(org)
    end
  end

  def get_pull_requests
    user_downloader.pull_requests.each do |pr|
      user.pull_requests.create_from_github(pr) unless pull_request_exists?(pr)
    end
  end

  private

  def user
    @user
  end

  def user_downloader
    @user_downloader ||= Rails.application.config.pull_request_downloader.call(user.nickname, @access_token)
  end

  def pull_request_exists?(pull_request)
    user.pull_requests.find_by_issue_url(pull_request['payload']['pull_request']['_links']['html']['href']).present?
  end
end
