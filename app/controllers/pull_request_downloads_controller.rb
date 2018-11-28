class PullRequestDownloadsController < ApplicationController
  before_action :ensure_logged_in

  def create
    Downloader.new(current_user).get_pull_requests
    contributions = current_user.contributions.year(current_year).order('created_at desc')
    current_user.gift_unspent_contributions!
    current_user.send_thank_you_email_on_24

    render :create, locals: { contributions: contributions }, layout: false
  end
end
