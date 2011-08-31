class GcalDaemon
  def initialize(email, password)
    @cal_service = GCal4Ruby::Service.new
    @cal_service.authenticate(email, password)
  end

  def run
    while true
      Room.find_all.each do |room|
        if cal = @cal_service.calendars.find{|c| c.id == room.calendar_id}
          current_event = cal.events.select{|e| e.start_time < Time.now || e.end_time > Time.now}.first
          if current_event
            room.event_desc = current_event.content
            room.next_reservation_at = current_event.start_time
            room.reservation_duration_secs = current_event.end_time - current_event.start_time
            room.save
          end
        end
      end
    end
  end
end

if $0 == __FILE__
  require "config/environment.rb"
  GcalDaemon.new(ARGV.shift, ARGV.shift).run
end