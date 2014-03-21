class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :user_logged_in?, :current_user

  def authenticate_user
    if not user_logged_in?
      redirect_to login_path
    end
  end

  def add_origin_header
    # For testing on your local machine on a normal browser, change this to your machine's IP
    #headers['Access-Control-Allow-Origin'] = 'http://localhost:8888';
    headers['Access-Control-Allow-Credentials'] = 'true';
    headers['Access-Control-Allow-Methods'] = 'GET, POST';
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With';
  end

  protected

  def current_user
    @user ||= User.find(session[:user_id]) if user_logged_in?
  end

  def user_logged_in?
    not session[:user_id].blank?
  end
end
