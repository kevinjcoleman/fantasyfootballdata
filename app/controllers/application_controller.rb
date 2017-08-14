class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_raven_context

  def current_user
    @user ||= User.find_by(uid: session[:uid]) if session[:uid]
  end
  helper_method :current_user

  private

    def set_raven_context
      if current_user
        Raven.user_context(id: "#{current_user.name}:#{current_user.uid}")
      else
        Raven.user_context(id: "visitor")
      end
      Raven.extra_context(params: params.to_unsafe_h, url: request.url)
    end
end
