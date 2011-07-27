class RoomController < ApplicationController
  
  before_filter :authenticate_to_gcal
  before_filter :verify_room_id_present, :only => [:add_event, :extend_event, :room_free, :vacate]
  
  EVENT_LENGTH_INCREMENT = 15.minutes
  
  def index
    @rooms = Room.all
  end
  
  def add_room
    
  end
  
  def add_event
    room = get_room(params[:room_number])
    calendar = GCal4Ruby::Calendar.find(@service, {:id => room.calendar_id})
    event = GCal4Ruby::Event.new(@service, {:calendar => calendar,
                                            :title => "Roomination",
                                            :start_time => Time.now,
                                            :end_time => Time.now + EVENT_LENGTH_INCREMENT,
                                            :where => room.room_name})
    render :json => {:success => event.save}
  end
  
  def report
    # gives slave id, reserved_button_presses, cancel_button_presses
    # returns current information
  end
  
  def extend_event
    room = get_room(params[:room_number])
    event = get_current_event(room)
    if event.present?
      event.end_time = event.end_time + EVENT_LENGTH_INCREMENT
    else
      return redirect_to add_event, :room_number => params[:room_number]
    end
    render :json => {:success => event.save}
  end
  
  def room_free?
    room = get_room(params[:room_number])
    render :json => {:free => !!get_current_event(room)}
  end
  
  def vacate
    room = get_room(params[:room_number])
    event = get_current_event(room)
    event.end_time = Time.now
    render :json => {:success => event.save}
  end
  
  def setup_rooms
    existing_rooms = Rooms.find(:all)
    
    params[:num_cols].to_i.times do |row|
      if row < existing_rooms.length # row already exists in the table
        room = existing_rooms[row]
        room.destroy and next if params["delete_#{row}"]
        room.updated_at = Time.now
      else
        next if params["delete_#{row}"]
        room = Rooms.new(:created_at => Time.now, :updated_at => Time.now)
      end
      
      room.calendar_name = params["text_c_name_#{row}"]
      room.calendar_id   = params["text_c_id_#{row}"]
      room.room_name     = params["text_r_name_#{row}"]
      room.room_number   = params["text_r_number_#{row}"]
      room.save!
    end
    
    redirect_to :back
  end
  
  def dev_null
    render :nothing => true
  end
  
  private
  
  def get_current_event(room)
    calendar = @service.calendars.select{|cal| cal.id == room.calendar_id}.first
    events = calendar.events
    # select any events not currently happening
    events = events.select{|e| e.start_time < Time.now && e.end_time > Time.now }
    debugger
    events.first #there should only be one event at a time, if not we'll just ignore it
  end
  
  def get_room(room_number)
    Room.find_by_room_number(room_number) rescue nil
  end
  
  def verify_room_id_present
    return redirect_to dev_null unless params[:room_number].present?
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
