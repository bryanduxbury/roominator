class RoomController < ApplicationController
  
  before_filter :authenticate_to_gcal

  OVERFLOW_VALUE = 255

  def index
    @rooms = Room.all
  end
  
  # gives slave id, reserved_button_presses, cancel_button_presses
  # returns current information
  def report
    room_number                = params[:room_number].to_i
    current_room                = Room.find_by_room_number(room_number)
    new_reserved_button_presses = params[:reserved_button_presses].to_i
    new_cancel_button_presses   = params[:cancel_button_presses].to_i
    
    delta_reserved_button_presses = (new_reserved_button_presses - current_room.reserved_button_presses).modulo(OVERFLOW_VALUE)
    delta_cancel_button_presses   = (new_cancel_button_presses   -   current_room.cancel_button_presses).modulo(OVERFLOW_VALUE)
    
    if delta_cancel_button_presses > 0
      current_room.cancel()
    else
      current_room.add_or_extend(@service, delta_reserved_button_presses) if delta_reserved_button_presses > 0
    end
    
    current_room.reserved_button_presses = new_reserved_button_presses
    current_room.reserved_button_presses = new_reserved_button_presses
    current_room.save!
    
    #return current_room.get_status()
    
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
end
