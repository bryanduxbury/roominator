class RoomController < ApplicationController
  
  before_filter :authenticate_to_gcal
  before_filter :set_current_event, :only => [:add_event, :extend_event, :room_free?, :vacate]
  
  EVENT_LENGTH_INCREMENT = 15.minutes
  OVERFLOW_VALUE = 255
  
  def index
    @rooms = Room.all
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
  
  # gives slave id, reserved_button_presses, cancel_button_presses
  # returns current information
  def report
    @room_number                = params[:room_number]
    current_room                = Room.find_by_room_number(@room_number)
    new_reserved_button_presses = params[:reserved_button_presses]
    new_cancel_button_presses   = params[:cancel_button_presses]
    
    delta_reserved_button_presses = (new_reserved_button_presses - current_room.reserved_button_presses).modulo(OVERFLOW_VALUE)
    delta_cancel_button_presses   = (new_cancel_button_presses   -   current_room.cancel_button_presses).modulo(OVERFLOW_VALUE)
    
    add_or_extend(delta_reserved_button_presses) if delta_reserved_button_presses > 0
    cancel if delta_cancel_button_presses > 0
    
    current_room.reserved_button_presses = new_reserved_button_presses
    current_room.reserved_button_presses = new_reserved_button_presses
    
    redirect_to get_status
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
  
  
  def room_free?
    room = get_room(params[:room_number])
    render :json => {:free => !!get_current_event(room)}
  end
  
  # gets the current event happening in this room and and changes its end time to right now
  def vacate
    @event.end_time = Time.now unless @event.nil?
    render :json => {:success => @event.save}
  end
  
  def setup_rooms
    existing_rooms = Room.find(:all)
    
    params[:num_cols].to_i.times do |row|
      if row < existing_rooms.length # row already exists in the table
        room = existing_rooms[row]
        room.destroy and next if params["delete_#{row}"]
        room.updated_at = Time.now
      else
        next if params["delete_#{row}"]
        room = Room.new(:created_at => Time.now, :updated_at => Time.now)
      end
      
      room.calendar_name = params["text_c_name_#{row}"]
      room.calendar_id   = params["text_c_id_#{row}"]
      room.room_name     = params["text_r_name_#{row}"]
      room.room_number   = params["text_r_number_#{row}"]
      room.save!
    end
    
    redirect_to :back
  end
  
  # this is a hack TODO clean this up
  # I redirect here if the any of the methods that require a room number are called without that parameter
  def dev_null
    render :nothing => true
  end
  
  private
  
  def set_current_event
    @room = Room.find_by_room_number(params[:room_number]) rescue nil
    debugger
    return redirect_to :controller => :room, :action => :dev_null if @room.nil? #trash the request if the room number was absent or bad
    @calendar = @service.calendars.select{|cal| cal.id == @room.calendar_id}.first #grab the calendar for this room
    events = @calendar.events
    events = events.select{|e| e.start_time < Time.now && e.end_time > Time.now } #select the events who start-end span includes now
    @event = events.first #there should only be one event at a time, if not we'll just ignore it
  end
end

# t.string   "calendar_name"
# t.integer  "calendar_id"
# t.string   "room_name"
# t.datetime "created_at"
# t.datetime "updated_at"
# t.integer  "room_number"
# t.string   "current_meeting"
# t.string   "next_meeting"
