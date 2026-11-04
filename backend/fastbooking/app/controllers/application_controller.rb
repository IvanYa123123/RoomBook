class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    return if logged_in?
    session[:return_to] = request.fullpath
    redirect_to login_path, alert: "Войдите, чтобы продолжить"
  end

  def require_guest
    return require_login unless logged_in?
    return if current_user.guest?
    redirect_to root_path, alert: "Раздел доступен только гостям"
  end

  def require_host
    return require_login unless logged_in?
    return if current_user.host?
    redirect_to root_path, alert: "Раздел доступен только владельцам отелей"
  end

  def parse_date(value)
    Date.parse(value.to_s)
  rescue ArgumentError, TypeError
    nil
  end
end
