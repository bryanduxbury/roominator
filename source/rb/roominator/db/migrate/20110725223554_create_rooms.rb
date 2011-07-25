class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.string :calendar_name
      t.integer  :calendar_id
      t.string :room_name
      t.timestamps
    end
  end

  def self.down
    drop_table :rooms
  end
end
