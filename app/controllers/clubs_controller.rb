class ClubsController < ApplicationController
  before_filter :get_club, :only=>[:show,:update,:edit,:destroy]

  def get_club
    @club = Club.find_by_permalink! params[:id]
  end

  def index
    @oauth ||= Koala::Facebook::OAuth.new
    if not session[:access_token]
      if params[:code]
        session[:access_token] = @oauth.get_access_token(params[:code], {redirect_uri: "http://localhost:3000/"})
      else
        redirect_to @oauth.url_for_oauth_code(permissions: "email", redirect_uri: "http://localhost:3000/") and return
      end
    else
      @graph = Koala::Facebook::API.new(session[:access_token])
      @fb_user = @graph.get_object("me")["id"]
      @fb_id = @fb_user['id']
      @user = User.where(fb_id: @fb_id)
     if @user.empty?
        if /\A[a-z]{1,8}@princeton.edu\z/.match @fb_user['email']
          # User.create()
          # redirect_to "/dat_ass" and return
        else
          # redirect_to "/dat_ass_2" and return
        end
     end
    end

    @clubs = Club.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clubs }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @club }
    end
  end
end
