class RoomController < ApplicationController

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
    room_number                = params[:id].to_i
    current_room                = Room.find_by_room_number(room_number)
    new_reserved_button_presses = params[:rsv].to_i
    new_cancel_button_presses   = params[:cancel].to_i
    
    #delta_reserved_button_presses = (new_reserved_button_presses - current_room.reserved_button_presses).modulo(OVERFLOW_VALUE)
    #delta_cancel_button_presses   = (new_cancel_button_presses   -   current_room.cancel_button_presses).modulo(OVERFLOW_VALUE)

    if new_cancel_button_presses > 0
      #current_room.cancel
      current_room.db_cancel
    elsif new_reserved_button_presses > 0
      #current_room.add_or_extend(new_reserved_button_presses)
      current_room.db_add_or_extend(new_reserved_button_presses)
    else
      current_room.refresh_cache
    end
    
    #current_room.reserved_button_presses = new_reserved_button_presses
    #current_room.cancel_button_presses = new_cancel_button_presses
    #current_room.save!

    response_data = current_room.get_status

    msg = response_data[:notice] || "Server Error"
    header = [200, # zero
             response_data[:status] || 0] # light

    tail = [ 200 ]
    header_in_binary = header.pack("C" * header.length) # "C" specifies: 8-bit unsigned
    tail_in_binary = tail.pack("C" * tail.length)
    data = header_in_binary + msg + tail_in_binary
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
