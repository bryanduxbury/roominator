class Display < ActiveRecord::Base
  belongs_to :room
  
  LED_NONE = 0
  LED_RED = 1
  LED_YELLOW = 2
  LED_GREEN = 3
  
  
  MSG_NA = 0
  MSG_WHO = 1
  MSG_WHAT = 2
  MSG_PENDING = 3
  
  def clear
    self.prev_msg = MSG_NA
    self.prev_led = LED_NONE
    self.timer = 0
    save!
  end
  
  def set_timer(val)
    self.timer = val
    save!
  end
  
  def incr_timer
    self.timer = timer + 1
    save!
  end
  
  def decr_timer
    self.timer = timer - 1
    save!
  end
  
end
