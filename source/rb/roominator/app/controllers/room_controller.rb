class RoomController < ApplicationController
  
  def index
    @rooms = Room.all
  end
  
  def add_room
    
  end
  
  def add_event
    
  end
  
  def extend_event
    
  end
  
  def room_free?
    
  end
  
  def vacate
    
  end
  
  def setup_rooms
    existing_rooms = Rooms.find(:all)
    
    params[:num_cols].to_i.times do |row|
      if row < existing_rooms.length # row already exists in the table
        room = existing_rooms[row]
        room.destroy and next if params["delete_#{row}"]
      else
        next if params["delete_#{row}"]
        room = Rooms.new(:created_at => Time.now, :created_at => Time.now)
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

# t.string   "calendar_name"
# t.integer  "calendar_id"
# t.string   "room_name"
# t.datetime "created_at"
# t.datetime "updated_at"
# t.integer  "room_number"
# t.string   "current_meeting"
# t.string   "next_meeting"