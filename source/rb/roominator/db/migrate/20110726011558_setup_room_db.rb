class SetupRoomDb < ActiveRecord::Migration
  def self.up
    add_column :rooms, :room_number, :int, :unique => true
    add_column :rooms, :current_meeting, :string
    add_column :rooms, :next_meeting, :string
  end

  def self.down
    remove_column :rooms, :room_number
    remove_column :rooms, :current_meeting, :string
    remove_column :rooms, :next_meeting, :string
  end
end
