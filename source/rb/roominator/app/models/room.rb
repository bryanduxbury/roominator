class Room < ActiveRecord::Base

  EVENT_LENGTH_INCREMENT = 15.minutes
  STATUS_MEETING_NOW = 2
  STATUS_MEETING_SOON = 1
  STATUS_NO_MEETING = 0

  serialize :next_event
  serialize :current_event

  def add_or_extend(service, multiplier = 1)
    set_instance_variables(service)
    notice_message = ""
    if @current_event.present?
      multiplier.times do
        if !@next_event || @current_event.end_time + EVENT_LENGTH_INCREMENT < @next_event.start_time
          @current_event.end_time = @current_event.end_time + EVENT_LENGTH_INCREMENT
        else
          notice_message = "Room already booked"
        end
      end
    else
      now = Time.now
      event_length = @next_event ? [@next_event.start_time - now, EVENT_LENGTH_INCREMENT * multiplier].min : EVENT_LENGTH_INCREMENT * multiplier
      @current_event = GCal4Ruby::Event.new(service, {:calendar => @calendar,
                                              :title => "Roomination",
                                              :start_time => now.utc.xmlschema,
                                              :end_time => (now + event_length).utc.xmlschema,
                                              :where => @room_name})
    end
    self.current_event = event_to_hash(@current_event)
    {:success => @current_event.save, :notice => notice_message}
  end

  # gets the current event happening in this room and and changes its end time to right now
  def cancel(service)
    if self.current_event.present?
      set_instance_variables(service)
      @current_event.end_time = Time.now
      self.current_event = nil
      return @current_event.save
    end
    return true
  end

  # sets the @room, @calendar, @event, and @next_event
  def set_instance_variables(service)
    @service = service
    @calendar = service.calendars.select{|cal| cal.id == self.calendar_id}.first #grab the calendar for this room
    events = @calendar.events
    currents = events.select{|e| e.start_time < Time.now && e.end_time > Time.now } #select the events who start-end span includes now
    @current_event = currents.first #there should only be one event at a time, if not we'll just ignore it
    self.current_event = event_to_hash(@current_event)
    next_events = events.select{|e| e.start_time > Time.now}
    @next_event = next_events.sort_by{|e| e.start_time}.first
    self.next_event = event_to_hash(@next_event)
  end

  # returns false if there is currently an event happening on the calendar associated with params(:room_number) room
  # true otherwise
  def room_free
    !self.current_event
  end

  def get_status
    occupied_until = self.current_event ? self.current_event[:end_time] : nil
    occupied_next = self.next_event ? self.next_event[:start_time] : nil

    #infer the color status
    if self.current_event
      status = STATUS_MEETING_NOW
    elsif self.next_event[:start_time] < Time.now + 15.minutes
      status = STATUS_MEETING_SOON
    else
      status = STATUS_NO_MEETING
    end

    #other info? check with bri/yan
    return {:status => status, :room_name => self.calendar_name, :occupied_until => occupied_until, :occupied_next => occupied_next}
  end

  def event_to_hash(event)
    event ? {:start_time => event.start_time, :end_time => event.end_time, :title => event.title} : nil
  end
end
