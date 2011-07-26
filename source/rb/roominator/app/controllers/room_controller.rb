class RoomController < ApplicationController

  before_filter :authenticate_to_gcal

  def index
    @rooms = Room.all
  end

  def add_room

  end

  def add_event
    room = Room.find_by_room_id(params[:room])
    calendar = Calendar.find(@service, {:id => room.calendar_id})
    event = Event.new(@service, {:calendar => calendar,
                                 :title => "Roomination",
                                 :start => Time.now,
                                 :end => Time.now + 15.minutes,
                                 :where => room.room_name})
    event.save
  end

  def extend_event
    room = Room.find_by_room_id(params[:room])
    calendar = Calendar.find(@service, {:id => room.calendar_id})
    events = Calendar.find(@service, {'start-max' => Time.now.utc.xmlschema, 'end-min' => Time.now.utc.xmlschema})
  end

  def room_free?

  end

  def vacate

  end

end
