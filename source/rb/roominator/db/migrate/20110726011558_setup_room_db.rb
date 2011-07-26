class SetupRoomDb < ActiveRecord::Migration
  def self.up
    add_column :rooms, :name , :string
    add_column :rooms, :room_number , :int
  end

  def self.down
    remove_column :rooms, :name
    remove_column :rooms, :room_number
  end
end
