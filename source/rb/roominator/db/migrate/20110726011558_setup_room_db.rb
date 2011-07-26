class SetupRoomDb < ActiveRecord::Migration
  def self.up
    add_column :rooms, :room_number, :int, :unique => true
  end

  def self.down
    remove_column :rooms, :room_number
  end
end
