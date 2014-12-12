class DashboardsController < ApplicationController
  before_action :ensure_logged_in, except: [:confirm_email, :locale]
  before_action :set_email_preferences, except: [:preferences, :update_preferences, :confirm_email, :locale]

  def show
    pull_requests = current_user.pull_requests.year(current_year).order('created_at desc')
    projects      = current_user.suggested_projects.limit(100).sample(12).sort_by(&:name)
    gifted_today  = current_user.gift_for(today)
    @events = Event.where(['start_time >= ?', Date.today]).order('start_time').first(5)

    if giftable_range? && current_user.unspent_pull_requests.any? && !gifted_today
      gift      = current_user.new_gift
      gift_form = GiftForm.new(gift: gift, pull_requests: current_user.unspent_pull_requests)
    end

    render :show, locals: { user:          current_user,
                            pull_requests: pull_requests,
                            projects:      projects,
                            gift_form:     gift_form }
  end

  def update_preferences
    current_user.skills.delete_all
    if current_user.update_attributes(user_params)
      flash[:success] = 'Your preferences was successfully saved'
      redirect_to :back
    else
      render :preferences
    end
  end

  def destroy
    current_user.destroy
    session.delete(:user_id)
    flash[:notice] = 'Your account was successfully deleted'
    redirect_to root_path
  end

  def resend_confirmation_email
    current_user.send_confirmation_email
    flash[:notice] = 'Confirmation email sent. Please check your inbox.'
    redirect_to :back
  end

  def confirm_email
    if params[:confirmation_token].present?
      user = User.where(confirmation_token: params[:confirmation_token]).first

      if user.present?
        user.confirm!
        flash[:notice] = 'Email address confirmed'
      else
        flash[:notice] = 'Unknown confirmation token'
      end
    end

    redirect_to root_path
  end

  def locale
    set_locale_to_cookie params[:locale]
    redirect_to(request.referer || root_path)
  end

  protected

  def today
    Time.zone.now.to_date
  end

  def giftable_range?
    today > Date.new(CURRENT_YEAR, 12, 1) && today < Date.new(CURRENT_YEAR, 12, 24)
  end

  def set_email_preferences
    redirect_to preferences_path unless current_user.email_frequency.present?
  end

  def user_params
    params.require(:user).permit(:uid, :provider, :nickname, :email, :gravatar_id, :token, :email_frequency, :twitter_token, skills_attributes: [:language])
  end

  def set_locale_to_cookie(locale)
    cookies[:locale] = { value:   locale,
                         expires: Time.zone.now + 36_000 }
  end
end
