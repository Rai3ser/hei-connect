class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_maintenance_mode, :set_locale
  helper_method :current_user, :user_logged_in

  def check_maintenance_mode
    if Rails.cache.read 'maintenance'
      session[:user_id] = nil if user_logged_in
      render file: 'public/maintenance', layout: false, status: 503
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def current_user
    @current_user ||=
        begin
          User.find(session[:user_id]) if session[:user_id]
        rescue
          session[:user_id] = nil
        end
  end

  def user_logged_in
    @user_loggin_in ||= !current_user.nil?
  end

  def require_login
    redirect_to root_url unless user_logged_in
  end

  def refresh_user_data
    current_user.update_schedule! if current_user.schedule_unknown?
    current_user.update_schedule! if current_user.expired_schedule?
  end
end
