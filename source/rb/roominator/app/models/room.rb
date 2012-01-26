class Room < ActiveRecord::Base
  has_one :display
  
  after_create :create_display
  
  # require 'yaml'
  EVENT_LENGTH_INCREMENT = 15.minutes.to_i
  EVENT_TITLE = "Roomination"
  ROOMINATOR_NAME = "Roominator"
  ROOMINATOR_EMAIL = "roominator.test@gmail.com"
  ROOMINATOR_CAL_ID = "roominator.test@gmail.com"
  
  def update_next_events(events = [])
    next_event = events.first
    next_next_event = events.second
    if next_event
      self.next_desc = next_event.title
      self.next_start = next_event.start_time
      self.next_end = next_event.end_time 
      self.next_reserved_by = next_event.attendees.select{|a| a[:role] == "organizer"}.first[:name]
    else
      self.next_desc = nil
      self.next_start = nil
      self.next_end = nil
      self.next_reserved_by = nil
    end
    if next_next_event
      self.next_next_start = next_next_event.start_time
    else
      self.next_next_start = nil
    end
    save!
  end
  
  private
  
  def create_display
    if !self.display
      Display.create(:room_id => self.id, :prev_msg => Display::MSG_NA, :prev_led => Display::LED_NONE, :timer => 0)
    end
  end
end