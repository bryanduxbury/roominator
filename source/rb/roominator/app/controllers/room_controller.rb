require "ruby-debug"
class RoomController < ApplicationController

  LBUTTON_DISABLED = 1
  LBUTTON_RESERVE = 2
  LBUTTON_EXTEND = 3

  RBUTTON_ENABLED = 1
  RBUTTON_DISABLED = 2
  
  MSG_COUNT = 1
  
  def self.seven_ten_split(str1, str2)
    "#{str1}#{' '*[1, (20 - str1.size - str2.size)].max}#{str2}"
  end
  
  EXTEND_CANCEL = RoomController.seven_ten_split("extend", "cancel")
  CANCEL = RoomController.seven_ten_split("", "cancel")
  RESERVE = RoomController.seven_ten_split("reserve", "")
  DISABLED = RoomController.seven_ten_split("", "")


  def index
    @rooms = Room.all
  end

  def data(line1, line2, line3, line4, led)
    [(line1 || "").center(20, ' '), 0,
      (line2 || "").center(20, ' '), 0,
      (line3 || "").center(20, ' '), 0,
      (line4 || "").center(20, ' '), 0,
      led].pack(("A20C" * 4) + "C")
  end
  
  def err_data(err)
    line1, line2, line3, line4 = split_across_lines(err)
    data(line1, line2, line3, line4, Display::LED_NONE)
  end

  def split_across_lines(str)
    if str.size <= 20
      return [str]
    end
    
    20.downto(1) do |i|
      if str[i..i] == " "
        return [str[0..(i-1)], split_across_lines(str[(i+1)..(str.size)])].flatten
      end
    end
    [str[0..20], split_across_lines(str[20..(str.size)])].flatten
  end
  
  # gives slave id, reserve_pressed, cancel_pressed
  # returns current information
  def report
    display_id = params[:id].to_i
    display = Display.find(display_id) rescue nil
    current_room = display && display.room
    
    if !display || !current_room
      render :text => err_data("Cannot find calendar for display with id #{display_id}")
      return
    end
    
    line1 = current_room.room_name
    
    if display.prev_msg == Display::MSG_PENDING
      if current_room.reserve_pressed || current_room.cancel_pressed
        # still pending, ignore button presses and everything else
        render :text => data(line1, "Request pending", "Please wait...", "", display.prev_led)
        return
      else
        # request complete, clear pending status
        display.clear
      end
    end
    
    reserve_pressed = params[:rsv].to_i == 1
    cancel_pressed = params[:cancel].to_i == 1
    
    reserved_at = current_room.next_start && current_room.next_start.localtime
    time_until_next_reservation = reserved_at ? reserved_at.to_i - Time.now.to_i : 1.0/0
    lbutton = LBUTTON_DISABLED;
    rbutton = RBUTTON_DISABLED;
    led = Display::LED_NONE;

    if time_until_next_reservation <= 0
      # reservation is currently happening
      led = Display::LED_RED
      rbutton = RBUTTON_ENABLED
      
      puts "TIMER #{display.timer}"
      if display.timer > 0
        # keep the prev message until count runs down
        display.decr_timer
      else
        puts "PREV MSG #{display.prev_msg}"
        new_msg = display.prev_msg == Display::MSG_WHAT ? Display::MSG_WHO : Display::MSG_WHAT
        display.set_timer(MSG_COUNT)
        display.prev_msg = new_msg
        display.prev_led = led
        display.save!
      end
      
      reserved_by = current_room.next_reserved_by
      if display.prev_msg == Display::MSG_WHO
        reserved_by = reserved_by[0..reserved_by.index('@')-1] if reserved_by =~ /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
      end
      
      line2 = "Booked until #{current_room.next_end.localtime.strftime("%I:%M%p %m/%d")}"
      line3 = display.prev_msg == Display::MSG_WHO ? "by #{reserved_by}" : "for #{current_room.next_desc}"
      line4 = CANCEL
      
      if !current_room.next_next_start || current_room.next_next_start - current_room.next_end >= Room::EVENT_LENGTH_INCREMENT
        # at least 15 min available to extend this reso before the next event
        lbutton = LBUTTON_EXTEND
        line4 = EXTEND_CANCEL
      end
    else
      # reservation is for a future date
      line2, line3 = reserved_at ? split_across_lines("Free until #{reserved_at.strftime("%I:%M%p %m/%d")}") : split_across_lines("No upcoming reservations")
      puts line2
      
      if (time_until_next_reservation < Room::EVENT_LENGTH_INCREMENT)
        # less than 15 min until next reso
        led = Display::LED_YELLOW
        line4 = DISABLED
      else
        led = Display::LED_GREEN
        lbutton = LBUTTON_RESERVE
        line4 = RESERVE
      end
      display.prev_msg = Display::MSG_NA
      display.prev_led = led
      display.save!
    end
    
    # Do nothing if both buttons were pressed
    if reserve_pressed && !cancel_pressed && lbutton != LBUTTON_DISABLED
      current_room.reserve_pressed = true
      current_room.save!
      puts "$$$$$$$$$$#{current_room.room_name} set to reserve/extend"
    elsif cancel_pressed && !reserve_pressed && rbutton != RBUTTON_DISABLED
      current_room.cancel_pressed = true
      current_room.save!
      puts "$$$$$$$$$$#{current_room.room_name} set to cancel reso"
    else
      puts "$$$$$$$$$$Nothing Happening"
    end
    
    if current_room.reserve_pressed || current_room.cancel_pressed
      # Should transition to pending status
      display.prev_led = led
      display.prev_msg = Display::MSG_PENDING
      display.save!
      data = data(line1, "Request pending", "Please wait...", "", led)
    else
      data = data(line1, line2, line3, line4, led)
    end

    render :text => data
  end

  def setup_rooms
    existing_rooms = Room.all

    params[:num_cols].to_i.times do |row|
      if row < existing_rooms.length # row already exists in the table
        room = existing_rooms[row]
        room.destroy and next if params["delete_#{row}"]
        room.updated_at = Time.now
      else
        next if params["delete_#{row}"]
        room = Room.create
      end

      room.calendar_name = params["text_c_name_#{row}"]
      room.calendar_id   = params["text_c_id_#{row}"]
      room.room_name     = params["text_r_name_#{row}"]
      room.save!
    end
    
    redirect_to :back
  end
end
