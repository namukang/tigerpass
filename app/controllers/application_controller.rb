class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def facebook_cookies
    @facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
  end

  # in other controllers
  # def index
    # ...
    # @access token = facebook_cookies['access_token']
    # @graph = Koala::Facebook::GraphAPI.new(@access_token)
    # ...
  # end
end

