class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :current_year, :admin?

  before_action :set_locale
  before_action :set_timezone
  before_action :restrict_pages, if: :json_request?
  before_action :title

  def set_locale
    I18n.locale = cookies[:locale] || I18n.default_locale
  end

  def set_timezone
    Time.zone = current_user.time_zone if logged_in? && current_user.time_zone.present?
  end

  def restrict_pages
    return if params[:page].to_i <= 100

    render json: [], status: :forbidden
  end

  private

  def json_request?
    request.format.json?
  end

  def ensure_logged_in
    return true if logged_in?
    session[:pre_login_destination] = "http://#{request.host_with_port}#{request.path}"
    redirect_to login_path,
                notice: t('.notice.not_logged_in',
                          default: 'You must be logged in to view this content.')
  end

  def current_year
    @year ||= (params[:year].try(:to_i) || Tfpullrequests::Application.current_year)
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def admin?
    current_user.admin?
  end

  def title
    meta_title = []
    action = t("meta_titles.#{controller_name}.#{action_name}", default: nil)
    meta_title.push(action) if action.present?
    meta_title.push(object_name) if object_name.present?
    meta_title.push("|") if meta_title.any?
    meta_title.push(t("meta_titles.site_name", default: "24 Pull Requests"))
    @title = meta_title.join(" ")
  end

  def object_name; end
end
