class RoomController < ApplicationController
  
  before_filter :authenticate_to_gcal
  before_filter :set_current_event, :only => [:add_event, :extend_event, :room_free?, :vacate]
  
  EVENT_LENGTH_INCREMENT = 15.minutes
  OVERFLOW_VALUE = 255
  STATUS_GREEN = 0
  STATUS_YELLOW = 1
  STATUS_RED = 2

  def index
    @rooms = Room.all
  end
  
  # gives slave id, reserved_button_presses, cancel_button_presses
  # returns current information
  def report
    @room_number                = params[:id].to_i
    current_room                = Room.find_by_room_number(@room_number)
    new_reserved_button_presses = params[:rsv].to_i
    new_cancel_button_presses   = params[:cancel].to_i
    
    delta_reserved_button_presses = (new_reserved_button_presses - current_room.reserved_button_presses).modulo(OVERFLOW_VALUE)
    delta_cancel_button_presses   = (new_cancel_button_presses   -   current_room.cancel_button_presses).modulo(OVERFLOW_VALUE)
    
    if delta_cancel_button_presses > 0
      cancel()
    else
      add_or_extend(delta_reserved_button_presses) if delta_reserved_button_presses > 0
    end
    
    current_room.reserved_button_presses = new_reserved_button_presses
    current_room.reserved_button_presses = new_reserved_button_presses
    current_room.save!
    
    msg = "I really want to test something"
    header = [ 0, # zero
               1, # light
               msg.length ] # length of msg
    header_in_binary = header.pack("C" * header.length) # "C" specifies: 8-bit unsigned integer (unsigned char)
    data = header_in_binary + msg
    render :text => data
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

  def add_or_extend(multiplier)
    set_current_event
    notice_message = ""
    if @event.present?
      multiplier.times do
        if @event.end_time + EVENT_LENGTH_INCREMENT < @next_event.start_time
          @event.end_time = @event.end_time + EVENT_LENGTH_INCREMENT
        else
          notice_message = "Room already booked"
        end
      end
    else
      now = Time.now
      event_length = [@next_event.start_time - now, EVENT_LENGTH_INCREMENT * multiplier].min
      @event = GCal4Ruby::Event.new(@service, {:calendar => @calendar,
                                              :title => "Roomination",
                                              :start_time => now.utc.xmlschema,
                                              :end_time => (now + event_length).utc.xmlschema,
                                              :where => @room.room_name})
    end
    {:success => @event.save, :notice => notice_message}
  end

  # returns false if there is currently an event happening on the calendar associated with params(:room_number) room
  # true otherwise
  def room_free
    set_current_event
    !@event
  end

  # gets the current event happening in this room and and changes its end time to right now
  def cancel
    set_current_event
    if @event.present?
      @event.end_time = Time.now unless @event.nil?
      return @event.save
    end
    return true
  end

  def set_current_event
    @room = Room.find_by_room_number(@room_number) rescue nil
    return redirect_to :controller => :room, :action => :dev_null if @room.nil? #trash the request if the room number was absent or bad
    @calendar = @service.calendars.select{|cal| cal.id == @room.calendar_id}.first #grab the calendar for this room
    events = @calendar.events
    current = events.select{|e| e.start_time < Time.now && e.end_time > Time.now } #select the events who start-end span includes now
    @event = current.first #there should only be one event at a time, if not we'll just ignore it
    next_events = events.select{|e| e.start_time > Time.now}
    @next_event = next_events.sort_by{|e| e.start_time}.first
    @next_event = GCal4Ruby::Event.new(@service, {:start_time => (Time.now + 10.years).utc.xmlschema}) if @next_event.nil? #dummy event if there's nothing on the calendar
  end

  def get_status
    #get the current event, time until it ends
    set_current_event
    occupied_until = @event ? @event.end_time : nil
    occupied_next = @next_event ? @next_event.start_time : nil
    #get the next event, time until it starts


    #get the name of the room
    room_name = @room.calendar_name


    #infer the color status
    if @event
      status = STATUS_RED
    elsif @next_event.start_time < Time.now + 15.minutes
      status = STATUS_YELLOW
    else
      status = STATUS_GREEN
    end

    #other info? check with bri/yan
    return {:status => status, :room_name => room_name, :occupied_until => occupied_until, :occupied_next => occupied_next}
  end
end
