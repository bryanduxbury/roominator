class SetDefaultValues < ActiveRecord::Migration
  def self.up
    change_column :rooms, :current_event, :text, :default => ""
    change_column :rooms, :next_event, :text, :default => ""
  end

  def self.down
  end
end
