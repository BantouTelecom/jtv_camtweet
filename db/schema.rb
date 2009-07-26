# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090720201150) do

  create_table "broadcasts", :force => true do |t|
    t.integer  "user_id"
    t.datetime "ended_at"
    t.text     "status"
    t.text     "uid"
    t.integer  "clip_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "clip_images"
  end

  create_table "invite_codes", :force => true do |t|
    t.text     "uid"
    t.integer  "available"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invites", :force => true do |t|
    t.text     "invitee_screen_name"
    t.text     "inviter_screen_name"
    t.boolean  "accepted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.text     "name"
    t.text     "screen_name"
    t.text     "password"
    t.text     "profile_image_url"
    t.text     "channel"
    t.integer  "twitter_id"
    t.text     "access_token"
    t.text     "access_token_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invites",             :default => 3
  end

end
