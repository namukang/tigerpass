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
          User.create()
          redirect_to "/dat_ass"
        else
          redirect_to "/dat_ass_2"
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

  def new
    @club = Club.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @club }
    end
  end

  def edit
  end

  def create
    @club = Club.new(params[:club])

    respond_to do |format|
      if @club.save
        format.html { redirect_to @club, notice: 'Club was successfully created.' }
        format.json { render json: @club, status: :created, location: @club }
      else
        format.html { render action: "new" }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @club.update_attributes(params[:club])
        format.html { redirect_to @club, notice: 'Club was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @club.destroy

    respond_to do |format|
      format.html { redirect_to clubs_url }
      format.json { head :no_content }
    end
  end
end
