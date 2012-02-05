class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def confirm_fb_auth
    if session[:access_expiry]
      if session[:access_expiry] <= Time.now
        session[:access_expiry] = nil
        session[:access_token] = nil
      end
    end
    unless session[:access_token]
      if session[:user_id]
        session[:user_id] = nil
        flash[:notice] = "You may have logged out of facebook, or your facebook session may have expired. Please login again."
        redirect_to "/fblogin"
        return false
      else
        flash[:notice] = "You must login to facebook to use Tigerpass."
        redirect_to "/fblogin"
        return false
      end
    else
      return true
    end
  end

  def confirm_user
    if confirm_fb_auth == false
      return false
    end
    if session[:user_id]
      return true
    end
    graph = Koala::Facebook::API.new(session[:access_token])
    fb_user = graph.get_object("me")["id"]
    fb_id = fb_user['id']
    fb_email = fb_user['email']
    user = User.where(fb_id: fb_id)
    if user.empty?
      if /\A[a-z]{1,8}@princeton.edu\z/.match(fb_email)
        session[:ug_authenticated] = true
        session[:new_netid] = fb_email.split('@').first
        session[:new_fb_id] = fb_id
        flash[:notice] = "It looks like you haven't used Tigerpass before. You'll need to create a user profile so we can get started."
        redirect_to "/newuser"
        return false # halts the before_filter
      else
        session[:ready_to_auth] = true
        flash[:notice] = "It looks like you haven't used Tigerpass before. We'll need to authenticate that you are a Princeton undergraduate student."
        redirect_to "/ugauth"
        return false
      end
    else
      session[:user_id] = fb_id
      return true
    end
  end

  def confirm_club_admin(clubid)
    if confirm_user == false
      return false
    end
    user = User.where(fb_id: session[:user_id])
    clubname = Club.find(clubid)['long_name']
    if user['admin_id'] != clubid or super_admin_netid(user['netid']) == false
      flash[:notice] = "You must be an officer of #{clubname} to access this page."
      redirect_to "/denied"
      return false # halts the before_filter
    else
      return true
    end
  end

  def confirm_super_admin
    if confirm_user == false
      return false
    end
    user = User.where(fb_id: session[:user_id])
    if super_admin_netid(user['netid']) == false
      flash[:notice] = "This page is accessible only to site administrators. Please contact us if you believe you are seeing this message in error."
      redirect_to "/denied"
      return false # halts the before_filter
    else
      return true
    end
  end

  def super_admin_netid(netid)
    if netid == "jasnyder" or netid == "dskang" or netid == "jconeill"
      return true
    else
      return false
    end
  end
end
