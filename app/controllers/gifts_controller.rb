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
                             :date => params[:date])

    render :new, :locals => { :gift_form => gift_form }
  end

  def create
    pull_request = current_user.pull_requests.find_by_id(pull_request_id)
    gift_params  = post_params.merge(:pull_request => pull_request)
    gift         = current_user.new_gift(gift_params)

    if gift.save
      flash[:notice] = "Your code has been gifted."
      redirect_to gifts_path()
    else
      gift_form = GiftForm.new(:gift => gift,
                               :pull_requests => current_user.pull_requests,
                               :giftable_dates => Gift.giftable_dates)

      render :new, :locals => { :gift_form => gift_form }
    end
  end


  def edit
    gift = current_user.gift_for(params[:id])

    gift_form = GiftForm.new(:gift => gift,
                             :pull_requests => current_user.pull_requests)

    render :new, :locals => { :gift_form => gift_form }
  end


  def update
    pull_request = current_user.pull_requests.find_by_id(pull_request_id)
    gift_params  = post_params.merge(:pull_request => pull_request)
    gift         = current_user.gift_for(params[:id])

    if gift.update_attributes(gift_params)
      flash[:notice] = "Your code has been gifted."
      redirect_to gifts_path()
    else
      gift_form = GiftForm.new(:gift => gift,
                               :pull_requests => current_user.pull_requests,
                               :giftable_dates => Gift.giftable_dates)

      render :new, :locals => { :gift_form => gift_form }
    end
  end

  private
  def pull_request_id
    params[:gift][:pull_request_id]
  end

  def post_params
    params[:gift].slice(:date)
  end
end
