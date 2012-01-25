class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.string :calendar_name
      t.string  :calendar_id
      t.string :room_name
      t.integer :display_id #should be made unique
      t.boolean :reserve_pressed
      t.boolean :cancel_pressed
      t.timestamp :next_start
      t.timestamp :next_end
      t.string :next_reserved_by
      t.string :next_desc
      t.timestamp :next_next_start
      t.timestamps
    end
  end

  def self.down
    drop_table :rooms
  end
end
