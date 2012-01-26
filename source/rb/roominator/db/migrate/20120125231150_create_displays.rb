class CreateDisplays < ActiveRecord::Migration
  def self.up
    create_table :displays do |t|
      t.integer :room_id
      t.integer :prev_msg
      t.integer :prev_led
      t.integer :timer

      t.timestamps
    end
    remove_column :rooms, :display_id
  end

  def self.down
    add_column :rooms, :display_id, :integer
    drop_table :displays
  end
end
