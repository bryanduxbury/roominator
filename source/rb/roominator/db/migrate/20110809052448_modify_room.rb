class ModifyRoom < ActiveRecord::Migration
  def self.up
    add_column :rooms, :reserved_by, :text, :default => ""
    add_column :rooms, :event_desc, :text, :default => ""
    add_column :rooms, :free_until_secs, :int
  end

  def self.down
  end
end
