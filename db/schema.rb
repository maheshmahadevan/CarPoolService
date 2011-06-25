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

ActiveRecord::Schema.define(:version => 20100718045023) do

  create_table "communities", :force => true do |t|
    t.string "name",        :limit => 50, :null => false
    t.string "commtype",    :limit => 20, :null => false
    t.string "city",        :limit => 30, :null => false
    t.string "state",       :limit => 2,  :null => false
    t.text   "description"
    t.string "moderator",   :limit => 50, :null => false
  end

  create_table "notifications", :force => true do |t|
    t.text      "message"
    t.string    "sender",    :limit => 50, :null => false
    t.string    "recipient", :limit => 50, :null => false
    t.timestamp "sent_time",               :null => false
  end

  create_table "offer_requests", :force => true do |t|
    t.string "requestType",    :limit => 1,  :null => false
    t.text   "startPoint",                   :null => false
    t.text   "endPoint",                     :null => false
    t.date   "date",                         :null => false
    t.time   "time",                         :null => false
    t.text   "additionalText"
    t.string "searchType",     :limit => 50, :null => false
  end

  create_table "user_communities", :force => true do |t|
    t.string "user",      :limit => 50, :null => false
    t.string "community", :limit => 50, :null => false
    t.string "moderator", :limit => 1,  :null => false
  end

  create_table "user_offers", :force => true do |t|
    t.string "user",      :limit => 50, :null => false
    t.string "community", :limit => 50, :null => false
    t.string "moderator", :limit => 1,  :null => false
  end

  create_table "users", :force => true do |t|
    t.string    "email",         :limit => 50, :null => false
    t.string    "password",      :limit => 20, :null => false
    t.date      "dob",                         :null => false
    t.string    "sex",           :limit => 1,  :null => false
    t.string    "location",      :limit => 20, :null => false
    t.string    "usertype",      :limit => 20, :null => false
    t.timestamp "cre_date_time",               :null => false
  end

end
