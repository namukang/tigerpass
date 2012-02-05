class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # Mark user as attending
  def attend
    event = Event.find(params[:event_id])
    user = User.find_by_fb_id(session[:user_id])
    if not user.attending? event
      user.events << event
    end
    render nothing: true
  end

  # Mark user as not attending
  def unattend
    event = Event.find(params[:event_id])
    user = User.find_by_fb_id(session[:user_id])
    if user.attending? event
      user.events.delete(event)
    end
    render nothing: true
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new()
    user = User.find_by_fb_id(session[:user_id])
    @event.club_id = user.admin_id
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])
    user = User.find_by_fb_id(session[:user_id])
    @event.club_id = user.admin_id

    respond_to do |format|
      if @event.save
        format.html { redirect_to events_path, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to events_path, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end
end
