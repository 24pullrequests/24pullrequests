module OrganisationHelper

  def organisation_count
    Organisation.count
  end

  def organisation_tooltip organisation
    user_count = organisation.users.count
    member = "member".pluralize(user_count)
    "#{organisation.login} - #{user_count} #{member} - #{organisation.pull_request_count} pull requests"
  end
end
