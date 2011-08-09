class AddReservedAt < ActiveRecord::Migration
  def self.up
    add_column :rooms, :next_reservation_at, :int
    add_column :rooms, :reservation_duration_secs, :int
  end

  def self.down
  end
end
