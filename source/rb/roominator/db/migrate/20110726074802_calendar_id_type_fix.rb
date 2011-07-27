class CalendarIdTypeFix < ActiveRecord::Migration
  def self.up
    remove_column :rooms, :calendar_id
    add_column :rooms, :calendar_id, :string
  end

  def self.down
  end
end
