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

ActiveRecord::Schema.define(:version => 20100528204027) do

  create_table "cities", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "state_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "communities", :force => true do |t|
    t.string   "title",                                :null => false
    t.string   "subtitle",                             :null => false
    t.integer  "city_id",                              :null => false
    t.boolean  "elite",             :default => false, :null => false
    t.boolean  "smart_share",       :default => false, :null => false
    t.boolean  "smart_rent",        :default => false, :null => false
    t.boolean  "green",             :default => false, :null => false
    t.boolean  "non_smoking",       :default => false, :null => false
    t.string   "website_url"
    t.string   "video_url"
    t.string   "facebook_url"
    t.string   "twitter_handle"
    t.string   "promo_image"
    t.string   "promo_url"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "street_address"
    t.text     "overview_text"
    t.text     "features_text"
    t.text     "neighborhood_text"
    t.text     "promotions_text"
    t.text     "contact_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "community_links", :force => true do |t|
    t.string   "title",        :null => false
    t.string   "url",          :null => false
    t.integer  "community_id", :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "community_pages", :force => true do |t|
    t.string   "title",        :null => false
    t.text     "content",      :null => false
    t.integer  "community_id", :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "floor_plan_groups", :force => true do |t|
    t.string   "name",         :null => false
    t.integer  "community_id", :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "floor_plans", :force => true do |t|
    t.string   "image",                                             :null => false
    t.string   "category",                                          :null => false
    t.integer  "bedrooms",                                          :null => false
    t.decimal  "bathrooms",           :precision => 3, :scale => 1, :null => false
    t.integer  "square_feet",                                       :null => false
    t.integer  "price",                                             :null => false
    t.integer  "floor_plan_group_id",                               :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.string   "image",        :null => false
    t.integer  "community_id", :null => false
    t.string   "caption",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", :force => true do |t|
    t.string   "code",       :null => false
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "typus_users", :force => true do |t|
    t.string   "first_name",       :default => "",    :null => false
    t.string   "last_name",        :default => "",    :null => false
    t.string   "role",                                :null => false
    t.string   "email",                               :null => false
    t.boolean  "status",           :default => false
    t.string   "token",                               :null => false
    t.string   "salt",                                :null => false
    t.string   "crypted_password",                    :null => false
    t.string   "preferences"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
