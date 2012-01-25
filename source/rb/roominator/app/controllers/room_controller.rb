require "ruby-debug"
class RoomController < ApplicationController

  OVERFLOW_VALUE = 255
  
  LED_NONE = 0
  LED_RED = 1
  LED_YELLOW = 2
  LED_GREEN = 3

  LBUTTON_DISABLED = 1
  LBUTTON_RESERVE = 2
  LBUTTON_EXTEND = 3

  RBUTTON_ENABLED = 1
  RBUTTON_DISABLED = 2


  def index
    @rooms = Room.all
  end

  @@x = 0;

  def split_across_lines(str)
    if str.size > 20
      20.downto(12) do |i|
        if str[i..i] == " "
          return [str[0..(i-1)], str[(i+1)..(i+20)]]
        end
      end
    end
    [str[0..20], str[20..40]]
  end

  # gives slave id, reserve_pressed, cancel_pressed
  # returns current information
  def report
    display_id = params[:id].to_i
    current_room = Room.find_by_display_id(display_id)
    #TODO if cannot find current_room, display message
    reserve_pressed = params[:rsv].to_i == 1
    cancel_pressed = params[:cancel].to_i == 1
    
    room_name = current_room.room_name.center(20, " ")

    reserved_at = current_room.next_start.localtime
    time_until_next_reservation = reserved_at.to_i - Time.now.to_i
    lbutton = LBUTTON_DISABLED;
    rbutton = RBUTTON_DISABLED;
    led = LED_NONE;

    if time_until_next_reservation <= 0
      # reservation is currently happening
      msg1Line1, msg1Line2 = split_across_lines("Reserved by #{current_room.next_reserved_by}")
      msg2Line1, msg2Line2 = split_across_lines("For #{current_room.next_desc}")
      msg3Line1, msg3Line2 = split_across_lines("Until #{current_room.next_end.localtime.strftime("%I:%M%p %m/%d")}")
      led = LED_RED
      rbutton = RBUTTON_ENABLED
      if current_room.next_next_start - current_room.next_end >= Room::EVENT_LENGTH_INCREMENT
        # at least 15 min available to extend this reso before the next event
        lbutton = LBUTTON_EXTEND
      end
    else
      # reservation is for a future date
      msg1Line1, msg1Line2 = split_across_lines("Free until #{reserved_at.strftime("%I:%M%p %m/%d")}")
      msg2Line1, msg2Line2 = split_across_lines("Free until #{reserved_at.strftime("%I:%M%p %m/%d")}")
      msg3Line1, msg3Line2 = split_across_lines("Free until #{reserved_at.strftime("%I:%M%p %m/%d")}")
      if (time_until_next_reservation < Room::EVENT_LENGTH_INCREMENT)
        # less than 15 min until next reso
        led = LED_YELLOW
      else
        led = LED_GREEN
        lbutton = LBUTTON_RESERVE
      end

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

    data = [room_name, 0,
      msg1Line1, 0,# msg1Line2, 0,
      msg2Line1, 0,# msg2Line2, 0,
      msg3Line1, 0, #msg3Line2, 0,
      # lbutton,
      # rbutton,
      led].pack(("A20C" * 4) + "C")
    #delta_reserved_button_presses = (new_reserved_button_presses - current_room.reserved_button_presses).modulo(OVERFLOW_VALUE)
    #delta_cancel_button_presses   = (new_cancel_button_presses   -   current_room.cancel_button_presses).modulo(OVERFLOW_VALUE)

    # if new_cancel_button_presses > 0
    #   #current_room.cancel
    #   current_room.db_cancel
    # elsif new_reserved_button_presses > 0
    #   #current_room.add_or_extend(new_reserved_button_presses)
    #   current_room.db_add_or_extend(new_reserved_button_presses)
    # else
    #   current_room.refresh_cache
    # end
    # 
    # #current_room.reserved_button_presses = new_reserved_button_presses
    # #current_room.cancel_button_presses = new_cancel_button_presses
    # #current_room.save!
    # 
    # response_data = current_room.get_status
    # 
    # msg = response_data[:notice] || "Server Error"
    # header = [200, # zero
    #          response_data[:status] || 0] # light
    # 
    # tail = [ 200 ]
    # header_in_binary = header.pack("C" * header.length) # "C" specifies: 8-bit unsigned
    # tail_in_binary = tail.pack("C" * tail.length)
    # data = header_in_binary + msg + tail_in_binary
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
        room = Room.new(:created_at => Time.now, :updated_at => Time.now)
      end

      room.calendar_name = params["text_c_name_#{row}"]
      room.calendar_id   = params["text_c_id_#{row}"]
      room.room_name     = params["text_r_name_#{row}"]
      room.display_id   = params["text_r_number_#{row}"]
      room.save!
    end
    
    redirect_to :back
  end
end
