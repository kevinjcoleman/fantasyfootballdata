class SessionsController < ApplicationController
  def create
    User.from_auth(auth)
    session[:uid] = auth.uid
    redirect_to root_path
  end

  def destroy
    session[:uid] = nil
    redirect_to root_path
  end

  def auth
    request.env['omniauth.auth']
  end
end