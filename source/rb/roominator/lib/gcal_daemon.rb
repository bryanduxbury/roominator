class GcalDaemon
  def initialize(email, password, sleep_time)
    @cal_service = GCal4Ruby::Service.new
    @cal_service.authenticate(email, password)
    @sleep_time = sleep_time
  end

  def run
    while true
      Room.find(:all).each do |room|
        puts "working on room #{room.room_name}"
        if cal = @cal_service.calendars.find{|c| CGI.unescape(c.id) == room.calendar_id}
          puts "found a calendar: #{cal}"
          events = cal.events.select{|e| e.end_time > Time.now}.sort_by{|e| e.start_time}
          next_event = events.first
          next_next_event = events.second
          if next_event
            room.next_desc = next_event.title
            room.next_start = next_event.start_time
            room.next_end = next_event.end_time 
            room.next_reserved_by = next_event.attendees.select{|a| a[:role] == "organizer"}.first[:name]
            room.save!
          end
          if next_next_event
            room.next_next_start = next_next_event.start_time
            room.save!
          end
        end
      end
      sleep @sleep_time.to_f/1000
    end
  end
end

if $0 == __FILE__
  require "config/environment.rb"
  GcalDaemon.new(ARGV.shift, ARGV.shift, ARGV.shift.to_i).run
end