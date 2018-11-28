class Downloader
  def initialize(user, access_token = user.token)
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
      if pull_request = pull_request_exists?(pr)
        pull_request.update(
          title:        pr['payload']['pull_request']['title'],
          body:         pr['payload']['pull_request']['body'],
          state:        pr['payload']['pull_request']['state'],
          merged:       pr['payload']['pull_request']['merged'],
          merged_by_id: (pr['payload']['pull_request']['merged_by'] || {})['id'],
          language:     pr['repo']['language']
        )
      else
        user.contributions.create_from_github(pr)
      end
    end
  end

  private

  attr_reader :user

  def user_downloader
    @user_downloader ||= Rails.application.config.pull_request_downloader.call(user.nickname, @access_token)
  end

  def pull_request_exists?(pull_request)
    user.contributions.find_by_issue_url(pull_request['payload']['pull_request']['_links']['html']['href'])
  end

  def gifted_any_today?
    user.gift_for(Time.zone.today).present?
  end

  def auto_gift_today(pull_request)
    user.gifts.create(contribution_id: pull_request.id, date: Time.zone.today)
  end
end
