class DashboardsController < ApplicationController
  before_action :ensure_logged_in, except: [:confirm_email, :locale]
  before_action :set_email_preferences, except: [:preferences, :update_preferences, :confirm_email, :locale]

  def show
    contributions = current_user
      .contributions_ignoring_organisations
      .year(current_year)
      .order('created_at desc')
      .to_a

    projects      = current_user.suggested_projects.order(Arel.sql("RANDOM()")).limit(12).sort_by(&:name)
    gifted_today  = current_user.gift_for(today)
    @events = Event.where(['start_time >= ?', Time.zone.today]).order('start_time').first(5)

    if giftable_range? && current_user.unspent_contributions.any? && !gifted_today
      gift      = current_user.new_gift
      gift_form = GiftForm.new(gift: gift, contributions: current_user.unspent_contributions)
    end

    @contribution = current_user.contributions.build

    render :show, locals: { user:          current_user,
                            contributions: contributions,
                            projects:      projects,
                            gift_form:     gift_form }
  end

  def preferences
    session[:preferences_referrer] = request.referrer unless current_user.email_frequency.nil?
  end

  def update_preferences
    current_user.skills.delete_all
    if current_user.update(user_params)
      redirect_to(session[:preferences_referrer] || dashboard_path, notice: 'Your preferences were successfully saved')
      session.delete(:preferences_referrer)
    else
      render :preferences
    end
  end

  def destroy
    current_user.destroy
    session.delete(:user_id)
    redirect_to root_path, notice: 'Your account was successfully deleted'
  end

  def resend_confirmation_email
    current_user.send_confirmation_email
    redirect_back(fallback_location: dashboard_path, notice: 'Confirmation email sent. Please check your inbox.')
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
    redirect_back(fallback_location: root_path)
  end

  protected

  def today
    Time.zone.now.to_date
  end

  def giftable_range?
    today > Date.new(Tfpullrequests::Application.current_year, 12, 1) && today < Date.new(Tfpullrequests::Application.current_year, 12, 24)
  end

  def set_email_preferences
    redirect_to preferences_path unless current_user.email_frequency.present?
  end

  def user_params
    params.require(:user).permit(:uid, :provider, :nickname, :email, :gravatar_id, :token, :email_frequency, :ignored_organisations_string, :time_zone, skills_attributes: [:language])
  end

  def set_locale_to_cookie(locale)
    cookies[:locale] = { value:   locale,
                         expires: Time.zone.now + 36_000 }
  end
end
