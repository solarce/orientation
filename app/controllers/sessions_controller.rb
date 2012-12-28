class SessionsController < ApplicationController
  def new
    origin = { origin: session["return_to"] }.to_query
    redirect_to("/auth/google_oauth2?#{origin}")
  end

  def create
    if user = User.find_or_create_from_omniauth(auth_hash)
      session[:user_id] = user.id
      flash[:notice] = "Signed in!"
    else
      flash[:error] = "You need a codescool.com or envylabs.com account to sign in."
    end
    # OmniAuth automaticall saves the HTTP_REFERER when you begin the auth process
    redirect_to( request.env['omniauth.origin'] || root_url )
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end