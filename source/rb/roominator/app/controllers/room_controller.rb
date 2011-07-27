class RoomController < ApplicationController

  before_filter :authenticate_to_gcal
  before_filter :set_current_event, :only => [:add_event, :extend_event, :room_free?, :vacate]

  EVENT_LENGTH_INCREMENT = 15.minutes

  def index
    @rooms = Room.all
  end

  def add_room

  end

  # finds the calendar associated with the room number and adds an event of EVENT_LENGTH_INCREMENT to it
  # If there is already an event taking place, it extends that one instead
  # params:
  # room_number - the internal identifier of the room which is being booked
  def add_event
    if !@event
      @event = GCal4Ruby::Event.new(@service, {:calendar => @calendar,
                                              :title => "Roomination",
                                              :start_time => Time.now,
                                              :end_time => Time.now + EVENT_LENGTH_INCREMENT,
                                              :where => @room.room_name})
    else
      return redirect_to :controller => :room, :action => :extend_event, :room_number => params[:room_number]
    end
    return render :json => {:success => @event.save}
  end

  # checks the calendar associated with the room specified, if there is currently an event it extends it by
  # EVENT_LENGTH_INCREMENT, if there is none it redirects to add_event
  # params:
  # room_number - the internal identifier of the room which is being booked
  def extend_event
    if @event.present?
      @event.end_time = @event.end_time + EVENT_LENGTH_INCREMENT
    else
      return redirect_to :controller => :room, :action => :add_event, :room_number => params[:room_number]
    end
    render :json => {:success => @event.save}
  end

  # returns false if there is currently an event happening on the calendar associated with params(:room_number) room
  # true otherwise
  def room_free
    render :json => {:free => !@event}
  end

  # gets the current event happening in this room and and changes its end time to right now
  def vacate
    @event.end_time = Time.now unless @event.nil?
    render :json => {:success => @event.save}
  end

  # this is a hack TODO clean this up
  # I redirect here if the any of the methods that require a room number are called without that parameter
  def dev_null
    render :nothing => true
  end

  private

  def set_current_event
    @room = Room.find_by_room_number(params[:room_number]) rescue nil
    return redirect_to :controller => :room, :action => :dev_null if @room.nil? #trash the request if the room number was absent or bad
    @calendar = @service.calendars.select{|cal| cal.id == @room.calendar_id}.first #grab the calendar for this room
    events = @calendar.events
    events = events.select{|e| e.start_time < Time.now && e.end_time > Time.now } #select the events who start-end span includes now
    @event = events.first #there should only be one event at a time, if not we'll just ignore it
  end
end
