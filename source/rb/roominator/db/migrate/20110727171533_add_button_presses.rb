class AddButtonPresses < ActiveRecord::Migration
  def self.up
    add_column :rooms, :reserved_button_presses, :int
    add_column :rooms, :cancel_button_presses, :int
  end
  
  def self.down
    remove_column :rooms, :reserved_button_presses
    remove_column :rooms, :cancel_button_presses
  end
end
