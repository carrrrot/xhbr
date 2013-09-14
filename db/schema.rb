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

ActiveRecord::Schema.define(:version => 20130914184130) do

  create_table "wb_access_tokens", :force => true do |t|
    t.integer  "wb_user_id", :limit => 8, :null => false
    t.string   "value",                   :null => false
    t.integer  "expires_at",              :null => false
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "wb_access_tokens", ["wb_user_id"], :name => "index_wb_access_tokens_on_wb_user_id"

  create_table "wb_status_frames", :force => true do |t|
    t.integer  "wb_status_id",    :limit => 8, :null => false
    t.integer  "attitudes_count",              :null => false
    t.integer  "comments_count",               :null => false
    t.integer  "reposts_count",                :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "wb_status_frames", ["wb_status_id", "created_at"], :name => "index_wb_status_frames_on_wb_status_id_and_created_at", :unique => true

  create_table "wb_statuses", :force => true do |t|
    t.integer  "wb_target_user_id", :limit => 8, :null => false
    t.string   "wb_id",                          :null => false
    t.string   "wb_mid",                         :null => false
    t.string   "wb_idstr",                       :null => false
    t.datetime "posted_at",                      :null => false
    t.text     "message",                        :null => false
    t.integer  "attitudes_count",                :null => false
    t.integer  "comments_count",                 :null => false
    t.integer  "reposts_count",                  :null => false
    t.string   "thumbnail_pic",                  :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "wb_statuses", ["wb_id"], :name => "index_wb_statuses_on_wb_id", :unique => true
  add_index "wb_statuses", ["wb_target_user_id"], :name => "index_wb_statuses_on_wb_target_user_id"

  create_table "wb_target_user_frames", :force => true do |t|
    t.integer  "wb_target_user_id",           :limit => 8,                :null => false
    t.integer  "followers_count",                          :default => 0, :null => false
    t.integer  "statuses_count"
    t.integer  "favourites_count"
    t.float    "followers_per_hour"
    t.float    "followers_per_hour_smoothed"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
  end

  add_index "wb_target_user_frames", ["wb_target_user_id", "created_at"], :name => "index_wb_target_user_frames_on_wb_target_user_id_and_created_at", :unique => true

  create_table "wb_target_users", :force => true do |t|
    t.integer  "wb_id",            :limit => 8,                :null => false
    t.string   "name",                                         :null => false
    t.string   "link",                                         :null => false
    t.text     "description",                                  :null => false
    t.string   "profile_img_link",                             :null => false
    t.integer  "followers_count",               :default => 0, :null => false
    t.integer  "friends_count"
    t.integer  "statuses_count"
    t.integer  "favourites_count"
    t.boolean  "verified",                                     :null => false
    t.text     "verified_reason"
    t.string   "lang"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "domain"
  end

  add_index "wb_target_users", ["wb_id"], :name => "index_wb_target_users_on_wb_id", :unique => true

  create_table "wb_users", :force => true do |t|
    t.integer  "wb_id",      :limit => 8, :null => false
    t.string   "name",                    :null => false
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "wb_users", ["wb_id"], :name => "index_wb_users_on_wb_id", :unique => true

end
