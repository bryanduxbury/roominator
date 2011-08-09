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

  # gives slave id, reserved_button_presses, cancel_button_presses
  # returns current information
  def report
    room_number                 = params[:id].to_i
    current_room                = Room.find_by_room_number(room_number)
    new_reserved_button_presses = params[:rsv].to_i
    new_cancel_button_presses   = params[:cancel].to_i

    room_name = current_room.room_name.center(20, " ")

    reserved_at = Time.at(current_room.next_reservation_at)
    puts Time.now
    puts reserved_at
    time_until_next_reservation = Time.now.to_i - reserved_at.to_i
    puts time_until_next_reservation
    lbutton = LBUTTON_DISABLED;
    rbutton = RBUTTON_DISABLED;
    led = LED_NONE;

    if time_until_next_reservation > 0
      # reservation is currently happening
      msg1Line1, msg1Line2 = split_across_lines("Reserved by #{current_room.reserved_by}")
      msg2Line1, msg2Line2 = split_across_lines("For #{current_room.event_desc}")
      msg3Line1, msg3Line2 = split_across_lines("Until #{(Time.now + current_room.reservation_duration_secs).strftime("%I:%M%p %m/%d")}")
      led = LED_RED
      rbutton = RBUTTON_ENABLED
      lbutton = LBUTTON_EXTEND
    else
      # reservation is for a future date
      msg1Line1, msg1Line2 = split_across_lines("Free until #{reserved_at.strftime("%I:%M%p %m/%d")}")
      msg2Line1, msg2Line2 = split_across_lines("Free until #{reserved_at.strftime("%I:%M%p %m/%d")}")
      msg3Line1, msg3Line2 = split_across_lines("Free until #{reserved_at.strftime("%I:%M%p %m/%d")}")
      if (time_until_next_reservation > -15*60)
        led = LED_YELLOW
      else
        led = LED_GREEN
        lbutton = LBUTTON_RESERVE
      end

    end

    data = [200, room_name, 0,
      msg1Line1, 0, msg1Line2, 0,
      msg2Line1, 0, msg2Line2, 0,
      msg3Line1, 0, msg3Line2, 0,
      lbutton,
      rbutton,
      led].pack("C" + ("A20C" * 7) + "CCC")
    puts data.length
    puts data.inspect

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
      room.room_number   = params["text_r_number_#{row}"]
      room.save!
    end
    
    redirect_to :back
  end
end
