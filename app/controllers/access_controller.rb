class AccessController < ApplicationController

  def fblogin
    oauth = Koala::Facebook::OAuth.new
    if Rails.env.production?
      base_uri = "http://www.tigerpass.me/"
    else
      base_uri = "http://localhost:5000/"
    end    
    redirect_uri = base_uri + "fblogin/"
    if params[:code]
      token = oauth.get_access_token_info(params[:code], {redirect_uri: redirect_uri})
      session[:access_token] = token['access_token']
      session[:access_expiry] = Time.now + token['expires'].to_i
      redirect_to base_uri and return
    else
      redirect_to oauth.url_for_oauth_code(permissions: "email", redirect_uri: redirect_uri) and return
    end
  end

  def newuser
  end

  def auth
  end

  def denied
  end

end
