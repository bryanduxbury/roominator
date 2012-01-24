class GcalDaemon
  def initialize(email, password, sleep_time)
    @cal_service = GCal4Ruby::Service.new
    @cal_service.authenticate(email, password)
    @cals_by_id = Hash[@cal_service.calendars.map{|cal| [CGI.unescape(cal.id), cal]}]
    @roominator_cal = @cals_by_id[Room::ROOMINATOR_CAL_ID]
    if !@roominator_cal
      raise "Could not find roominator calendar with id #{Room::ROOMINATOR_CAL_ID} in calendar ids #{@cals_by_id.keys}"
    end
    @sleep_time = sleep_time
  end

  def run
    while true
      Room.find(:all).each do |room|
        puts "working on room #{room.room_name}"
        if cal = @cal_service.calendars.find{|c| CGI.unescape(c.id) == room.calendar_id}
          puts "found a calendar: #{cal}"
          events = cal.events.select{|e| e.end_time > Time.now}.sort_by{|e| e.start_time}
          
          # Handle button presses
          if room.reserve_pressed && room.cancel_pressed
            #TODO Unexpected Error
            puts "Both reserve and cancel pressed. Should not get to this point."
            # Do neither action
            room.reserve_pressed = false
            room.cancel_pressed = false
            room.save!
          elsif room.reserve_pressed
            handle_reserve_pressed(room, events)
          elsif room.cancel_pressed
            handle_cancel_pressed(room)
          end
          
          # Update rooms events
          next_event = events.first
          next_next_event = events.second
          if next_event
            room.next_desc = next_event.title
            room.next_start = next_event.start_time
            room.next_end = next_event.end_time 
            room.next_reserved_by = next_event.attendees.select{|a| a[:role] == "organizer"}.first[:name]
            room.save!
          end
          if next_next_event
            room.next_next_start = next_next_event.start_time
            room.save!
          end
        end
      end
      sleep @sleep_time.to_f/1000
    end
  end
  
  # Assumes it has already been verified that a reservation
  # action can occur
  def handle_reserve_pressed(room, events)
    room.reserve_pressed = false
    room.save!
    
    # check if should extend reso or make new
    if room.next_start && room.next_end && room.next_start < Time.now && room.next_end > Time.now
      # extend endtime of current event
      cur_event = events.find{|event| event.start_time == room.next_start && event.title == room.next_desc}
      if cur_event
        cur_event.end_time = get_end_time(cur_event.end_time, room.next_next_start)
        cur_event.save
      else
        #TODO Unexpected Error
        puts "Couldn't find event #{room.next_desc} at #{room.next_start} reserved by #{room.next_reserved_by}"
      end
    else
      # create new reservation
      event = GCal4Ruby::Event.new(@cal_service)
      event.calendar = @roominator_cal
      event.title = Room::EVENT_TITLE
      event.where = room.room_name
      event.start_time = Time.now
      event.end_time = get_end_time(event.start_time, room.next_start)
      event.attendees = [{:name => room.room_name, :email => room.calender_id, :role => "Attendee", :status => "Attending"}]
      event.save
    end
  end
  
  # Assumes it has already been verified that an event is occuring
  def handle_cancel_pressed(room)
    room.cancel_pressed = false
    room.save!
    
    if room.next_start && room.next_end && room.next_start < Time.now && room.next_end > Time.now
      cur_event = events.find{|event| event.start_time == room.next_start && event.title == room.next_desc}
      if cur_event
        cur_event.delete
      else
        #TODO Unexpected Error
        puts "Couldn't find event #{room.next_desc} at #{room.next_start} reserved by #{room.next_reserved_by}"
      end
    else
      #TODO Unexpected Error
      puts "No event to cancel. Shouldn't have gotten to this point."
    end
  end
  
  def get_end_time(to_extend, next_start_time)
    end_time = to_extend + ROOM::EVENT_LENGTH_INCREMENT
    if next_start_time && next_start_time < end_time
      # make sure not to end an event into the start of the next event
      end_time = next_start_time
    end
    end_time
  end
end

if $0 == __FILE__
  require "config/environment.rb"
  GCal4RubyDaemon.new(ARGV.shift, ARGV.shift, ARGV.shift.to_i).run
end