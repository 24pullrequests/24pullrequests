module OrganisationHelper

  def organisation_count
    Organisation.count
  end

  def organisation_tooltip organisation
    #when organizations are fetched without using "with_user_counts" (eg. @user.organizations), we would not have 'users_count'
    user_count = organisation.respond_to?(:users_count) ? organisation.users_count : organisation.users.count
    
    member = "member".pluralize(user_count)
    "#{organisation.login} - #{user_count} #{member} - #{organisation.pull_request_count} pull requests"
  end
end
