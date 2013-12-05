class GiftsController < ApplicationController
  before_filter :ensure_logged_in

  def index
    calendar  = Calendar.new(Gift.giftable_dates, current_user.gifts)

    render :index, :locals => { :calendar  => calendar }
  end

  def new
    gift_form = GiftForm.new(:gift           => current_user.new_gift,
                             :pull_requests  => current_user.unspent_pull_requests,
                             :giftable_dates => Gift.giftable_dates,
                             :date => params['date'])

    render :new, :locals => { :gift_form => gift_form }
  end

  def create
    gift = current_user.new_gift(gift_params)

    if gift.save
      gift_given
    else
      gift_failed(gift)
    end
  end

  def edit
    gift_form = GiftForm.new(:gift => gift,
                             :pull_requests => current_user.unspent_pull_requests

    render :new, :locals => { :gift_form => gift_form }
  end


  def update
    if gift.update_attributes(gift_params)
      gift_given
    else
      gift_failed(gift)
    end
  end

  def destroy
    gift.destroy

    redirect_to user_path(current_user), :alert => "Gift removed"
  end

  private

  def gift
    @gift ||= current_user.gift_for(params[:id])
  end

  def gift_params
    pull_request = current_user.pull_requests.year(current_year).find_by_id(pull_request_id)
    post_params.merge(:pull_request => pull_request)
  end

  def gift_given
    flash[:notice] = "Your code has been gifted."
    redirect_to gifts_path()
  end

  def gift_failed(gift)
    gift_form = GiftForm.new(:gift => gift,
                             :pull_requests => current_user.unspent_pull_requests,
                             :giftable_dates => Gift.giftable_dates)

    render :new, :locals => { :gift_form => gift_form }
  end

  def pull_request_id
    params[:gift].permit(:pull_request_id)[:pull_request_id]
  end

  def post_params
    params[:gift].permit(:date).slice(:date)
  end
end
