class UpdateRoomToSupportCaching < ActiveRecord::Migration
  def self.up
    remove_column :rooms, :next_meeting
    remove_column :rooms, :current_meeting
    add_column  :rooms, :current_event, :text
    add_column  :rooms, :next_event, :text
    add_column  :rooms, :calendar, :text
  end

  def self.down
    add_column :rooms, :next_meeting, :string
    add_column :rooms, :current_meeting, :string
    remove_column  :rooms, :current_event
    remove_column  :rooms, :next_event
    remove_column  :rooms, :calendar
  end
end
