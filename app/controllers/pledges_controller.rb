class PledgesController < ApplicationController
  before_action :ensure_logged_in, only: :create

  def show
  end

  def create
    if params[:agree] == '1'
      current_user.pledge!
      redirect_to session.delete(:pre_pledge_destination) || dashboard_path
    else
      flash.now[:alert] = t('pledge.must_agree')
      render :show, status: :unprocessable_entity
    end
  end

  def pledge_exempt?
    true
  end
end
