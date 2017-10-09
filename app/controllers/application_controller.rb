class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :email_to_kev

  def current_user
    @user ||= User.find_by(uid: session[:uid]) if session[:uid]
  end
  helper_method :current_user
end
