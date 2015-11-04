class PullRequestDownloadsController < ApplicationController
  before_action :ensure_logged_in

  def create
    Downloader.new(current_user).get_pull_requests
    pull_requests = current_user.pull_requests.year(current_year).order('created_at desc')
    current_user.gift_unspent_pull_requests!
    current_user.send_thank_you_email_on_24

    render :create, locals: { pull_requests: pull_requests }, layout: false
  end
end
