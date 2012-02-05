class ClubsController < ApplicationController
  before_filter :get_club, :only=>[:show]

  def get_club
    @club = Club.find_by_permalink! params[:id]
  end

  def index
    # FB auth
    @oauth ||= Koala::Facebook::OAuth.new
    if Rails.env.production?
      redirect_uri = "http://www.tigerpass.me/"
    else
      redirect_uri = "http://localhost:5000/"
    end
    if not session[:access_token]
      if params[:code]
        session[:access_token] = @oauth.get_access_token(params[:code], {redirect_uri: redirect_uri})
      else
        redirect_to @oauth.url_for_oauth_code(permissions: "email", redirect_uri: redirect_uri) and return
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

    # Show all the clubs and events
    @clubs = Club.all
    @events = Event.where(date: Date.today..(Date.today + 1.week))
    # Figure out order of buttons
    days_of_week = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    @days = []
    cur_day = Date.today.wday
    for i in 0..6
      @days << days_of_week[(cur_day + i) % 7]
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clubs }
    end
  end

  def show
    # Show the events for the specific club for that week
    @events = Event.where(club_id: @club.id, date: Date.today..(Date.today + 1.week))
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @club }
    end
  end
end
