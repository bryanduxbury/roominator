# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120125231150) do

  create_table "displays", :force => true do |t|
    t.integer  "room_id"
    t.integer  "prev_msg"
    t.integer  "prev_led"
    t.integer  "timer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rooms", :force => true do |t|
    t.string   "calendar_name"
    t.string   "calendar_id"
    t.string   "room_name"
    t.boolean  "reserve_pressed"
    t.boolean  "cancel_pressed"
    t.datetime "next_start"
    t.datetime "next_end"
    t.string   "next_reserved_by"
    t.string   "next_desc"
    t.datetime "next_next_start"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
