# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20120202164347) do

  create_table "clubs", :force => true do |t|
    t.string   "short_name"
    t.string   "long_name"
    t.string   "logo"
    t.string   "permalink"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "club_id"
    t.date     "date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "title"
    t.text     "description"
    t.string   "access"
    t.string   "image_small"
    t.string   "image_poster"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "events_users", :id => false, :force => true do |t|
    t.integer "event_id"
    t.integer "user_id"
  end

  add_index "events_users", ["event_id"], :name => "index_events_users_on_event_id"
  add_index "events_users", ["user_id"], :name => "index_events_users_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "netid"
    t.integer  "fb_id"
    t.integer  "year"
    t.integer  "club_id"
    t.integer  "admin_id"
    t.string   "email_auth"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users", ["fb_id"], :name => "index_users_on_fb_id"
  add_index "users", ["netid"], :name => "index_users_on_netid"

end
