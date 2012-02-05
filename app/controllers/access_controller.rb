class AccessController < ApplicationController
  before_filter :confirm_fb_auth, except: [:fblogin]

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
    if params[:auth_code] && params[:auth_netid]
      authuser = Auth.where(netid: params[:auth_netid])
      if authuser.empty?
        redirect_to "/denied" and return
      end
      if authuser.first.code == params[:auth_code]
        session[:ug_authenticated] = true
        session[:new_netid] = authuser.first.netid
        session[:new_fb_id] = authuser.first.fb_id
        if authuser.first.admin_id
          session[:new_admin_id] = authuser.first.admin_id
        end
      else
        redirect_to "/denied" and return
      end
    end
    unless session[:ug_authenticated] == true
      redirect_to "/denied" and return
    end
  end

  def finishuser
    unless session[:ug_authenticated] == true && params[:user]
      redirect_to "/denied" and return
    end
    newuser = User.new(params[:user])
    newuser.netid = session[:new_netid]
    newuser.fb_id = session[:new_fb_id]
    newuser.admin_id = session[:new_admin_id]
    if newuser.save
      session[:ug_authenticated] = nil
      session[:new_netid] = nil
      session[:new_fb_id] = nil
      session[:new_admin_id] = nil
      redirect_to "/denied" and return # not actually denied, just
      # getting back to homepage
    else
      redirect_to "/newuser"
    end
  end

  def auth    
    unless session[:ready_to_auth] == true
      redirect_to "/denied" and return
    end
    unless ENV['EM_PASS']
      raise "couldn't find stored email password"
    end
    Pony.options = { 
      from: 'tigerpassauth@gmail.com', 
      via: :smtp, 
      via_options: {
        address: 'smtp.gmail.com',
        port: '587',
        enable_starttls_auto: true,
        user_name: 'tigerpassauth@gmail.com',
        password: ENV['EM_PASS'].to_s,
        authentication: :plain,
        domain: "www.tigerpass.me"
      }
    }
    session[:ready_to_auth] = false
    session[:ready_to_email] = true
  end

  def sendauthemail
    unless session[:ready_to_email] == true and params[:email_netid] and session[:access_token]
      redirect_to "/denied" and return
    end
    getnetid = params[:email_netid]
    authuser = Auth.where(netid: getnetid)
    if authuser.empty?
      redirect_to "/ugonly" and return
    end
    if authuser.first.code
      redirect_to "/ugonly" and return # should instead tell the user
      # that a code has already been sent and offer them a chance to
      # resend unless authuser.first.code == "authenticatedviafbemail"
    end
    email_dest = getnetid.to_s + "@princeton.edu"
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    random = ""
    1.upto(25) { |i| random << chars[rand(chars.size-1)] }
    authuser.first.code = random
    graph = Koala::Facebook::API.new(session[:access_token])
    authuser.first.fb_id = graph.get_object("me")['id'].to_i
    authuser.first.save
    if Rails.env.production?
      base_uri = "http://www.tigerpass.me/"
    else
      base_uri = "http://localhost:5000/"
    end    
    Pony.mail(to: email_dest, subject: "TigerPass Authentication", body: "click me: #{base_uri}newuser?auth_code=#{random}&auth_netid=#{getnetid}")
    session[:ready_to_email] = false
    redirect_to "http://webmail.princeton.edu/" and return
  end

  def denied
    if Rails.env.production?
      base_uri = "http://www.tigerpass.me/"
    else
      base_uri = "http://localhost:5000/"
    end    
    redirect_to base_uri and return 
  end

  def ugonly
    if Rails.env.production?
      base_uri = "http://www.tigerpass.me/"
    else
      base_uri = "http://localhost:5000/"
    end    
    redirect_to base_uri and return 
  end
end
