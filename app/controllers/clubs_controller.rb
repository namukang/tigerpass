class ClubsController < ApplicationController
  before_filter :confirm_user, only: [:index]
  before_filter :get_club, :only=>[:show]

  def get_club
    @club = Club.find_by_permalink! params[:id]
  end

  def index
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

    # Find friends who are attending today's events
    # (Friends for other events will be found through AJAX requests)

    # today_events = Array.new
    # @events.each do |event|
    #   if event.date == Date.today
    #     today_events << event
    #   end
    # end
    # @friends = Hash.new
    # today_events.each do |event|
    #   @friends[event.id] = Set.new
    # end
    # graph = Koala::Facebook::API.new(session[:access_token])
    # friend_ids = graph.get_connections("me", "friends", fields: "id")

    # Hash of event to set of friends attending

    # friend_ids.each do |friend_id|
    #   friend = User.find_by_fb_id(friend_id['id'])
    #   if not friend.nil?
    #     today_events.each do |event|
    #       if friend.attending? event
    #         @friends[event.id].add(friend)
    #       end
    #     end
    #   end
    # end

    # TODO: Uncomment when user_id available
    # @user = User.find_by_fb_id(session[:user_id])
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
