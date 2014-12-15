class PullRequestsDecorator < AppDecorator
  delegate_all

  attributes :count, :total_pages

  def total_pages
    object.page(1).total_pages
  end

  def paginated
    object.page(1)
  end

end
