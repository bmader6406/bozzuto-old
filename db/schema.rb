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

ActiveRecord::Schema.define(:version => 20100716040931) do

  create_table "apartment_communities_landing_pages", :id => false, :force => true do |t|
    t.integer "landing_page_id"
    t.integer "apartment_community_id"
  end

  create_table "apartment_floor_plan_groups", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apartment_floor_plans", :force => true do |t|
    t.string   "image_url"
    t.integer  "bedrooms",                                                                 :null => false
    t.decimal  "bathrooms",               :precision => 3, :scale => 1,                    :null => false
    t.integer  "floor_plan_group_id",                                                      :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                                                                     :null => false
    t.string   "availability_url",                                                         :null => false
    t.integer  "min_square_feet",                                                          :null => false
    t.integer  "max_square_feet",                                                          :null => false
    t.decimal  "min_market_rent",         :precision => 6, :scale => 2,                    :null => false
    t.decimal  "max_market_rent",         :precision => 6, :scale => 2,                    :null => false
    t.decimal  "min_effective_rent",      :precision => 6, :scale => 2,                    :null => false
    t.decimal  "max_effective_rent",      :precision => 6, :scale => 2,                    :null => false
    t.integer  "apartment_community_id",                                                   :null => false
    t.decimal  "min_rent",                :precision => 6, :scale => 2,                    :null => false
    t.decimal  "max_rent",                :precision => 6, :scale => 2,                    :null => false
    t.integer  "image_type",                                            :default => 0,     :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "vaultware_floor_plan_id"
    t.integer  "vaultware_file_id"
    t.boolean  "featured",                                              :default => false, :null => false
  end

  create_table "awards", :force => true do |t|
    t.string   "title",                           :null => false
    t.text     "body"
    t.integer  "section_id"
    t.boolean  "published",    :default => false, :null => false
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "body_slides", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "body_slideshow_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "body_slideshows", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "buzzes", :force => true do |t|
    t.string   "email",        :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "phone"
    t.string   "buzzes",       :null => false
    t.string   "affiliations", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "state_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities_counties", :id => false, :force => true do |t|
    t.integer "city_id"
    t.integer "county_id"
  end

  create_table "counties", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "state_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "featured_apartment_communities_landing_pages", :id => false, :force => true do |t|
    t.integer "landing_page_id"
    t.integer "apartment_community_id"
  end

  create_table "feed_items", :force => true do |t|
    t.string   "title",        :null => false
    t.string   "url",          :null => false
    t.string   "description",  :null => false
    t.datetime "published_at", :null => false
    t.integer  "feed_id",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", :force => true do |t|
    t.string   "url",          :null => false
    t.datetime "refreshed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",         :null => false
  end

  create_table "home_communities_landing_pages", :id => false, :force => true do |t|
    t.integer "landing_page_id"
    t.integer "home_community_id"
  end

  create_table "home_floor_plans", :force => true do |t|
    t.string   "name",               :null => false
    t.string   "image_file_name",    :null => false
    t.integer  "home_id",            :null => false
    t.string   "image_content_type"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "home_page_slides", :force => true do |t|
    t.integer  "home_page_id",       :null => false
    t.string   "image_file_name",    :null => false
    t.string   "image_content_type", :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "home_pages", :force => true do |t|
    t.text     "body"
    t.integer  "featured_property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
  end

  create_table "homes", :force => true do |t|
    t.string   "name",                                                               :null => false
    t.integer  "bedrooms",                                                           :null => false
    t.decimal  "bathrooms",         :precision => 3, :scale => 1,                    :null => false
    t.integer  "home_community_id",                                                  :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "featured",                                        :default => false, :null => false
  end

  create_table "landing_pages", :force => true do |t|
    t.string   "title",                       :null => false
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.string   "cached_slug"
    t.integer  "state_id",                    :null => false
    t.text     "masthead_body"
    t.string   "masthead_image_file_name"
    t.string   "masthead_image_content_type"
    t.string   "secondary_title"
    t.text     "secondary_body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "landing_pages_popular_properties", :id => false, :force => true do |t|
    t.integer "landing_page_id"
    t.integer "property_id"
  end

  create_table "landing_pages_projects", :id => false, :force => true do |t|
    t.integer "landing_page_id"
    t.integer "project_id"
  end

  add_index "landing_pages_projects", ["landing_page_id", "project_id"], :name => "index_landing_pages_projects_on_landing_page_id_and_project_id"

  create_table "masthead_slides", :force => true do |t|
    t.text     "body",                                 :null => false
    t.integer  "slide_type",            :default => 0, :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_link"
    t.text     "sidebar_text"
    t.integer  "featured_property_id"
    t.integer  "masthead_slideshow_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "masthead_slideshows", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_posts", :force => true do |t|
    t.string   "title",                               :null => false
    t.text     "body"
    t.boolean  "published",        :default => false, :null => false
    t.datetime "published_at"
    t.integer  "section_id",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
  end

  create_table "pages", :force => true do |t|
    t.string   "title",            :null => false
    t.string   "cached_slug"
    t.text     "body"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "path"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
  end

  add_index "pages", ["path"], :name => "index_pages_on_path"

  create_table "photo_groups", :force => true do |t|
    t.string   "title",            :null => false
    t.string   "flickr_raw_title", :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photo_groups_photos", :id => false, :force => true do |t|
    t.integer "photo_group_id"
    t.integer "photo_id"
  end

  create_table "photo_sets", :force => true do |t|
    t.string   "title",                                :null => false
    t.string   "flickr_set_number",                    :null => false
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "needs_sync",        :default => false, :null => false
  end

  create_table "photos", :force => true do |t|
    t.string   "image_file_name"
    t.string   "title",              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_content_type"
    t.string   "flickr_photo_id",    :null => false
    t.integer  "photo_set_id"
    t.integer  "position"
  end

  create_table "project_categories", :force => true do |t|
    t.string   "title",       :null => false
    t.string   "cached_slug"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_categories", ["cached_slug"], :name => "index_project_categories_on_cached_slug"

  create_table "project_categories_projects", :id => false, :force => true do |t|
    t.integer "project_category_id"
    t.integer "project_id"
  end

  create_table "project_data_points", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "data",       :null => false
    t.integer  "project_id", :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_updates", :force => true do |t|
    t.text     "body",                            :null => false
    t.integer  "project_id",                      :null => false
    t.boolean  "published",    :default => false, :null => false
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "properties", :force => true do |t|
    t.string   "title",                                         :null => false
    t.string   "subtitle"
    t.integer  "city_id",                                       :null => false
    t.boolean  "elite",                      :default => false, :null => false
    t.boolean  "smart_share",                :default => false, :null => false
    t.boolean  "smart_rent",                 :default => false, :null => false
    t.boolean  "green",                      :default => false, :null => false
    t.boolean  "non_smoking",                :default => false, :null => false
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
    t.text     "features_1_text"
    t.text     "neighborhood_text"
    t.text     "promotions_text"
    t.text     "contact_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "local_info_feed_id"
    t.integer  "vaultware_id"
    t.boolean  "use_market_prices",          :default => false, :null => false
    t.string   "availability_url"
    t.string   "type"
    t.integer  "section_id"
    t.integer  "county_id"
    t.string   "listing_image_file_name"
    t.string   "listing_image_content_type"
    t.string   "listing_title"
    t.text     "listing_text"
    t.integer  "features"
    t.string   "overview_title"
    t.string   "overview_bullet_1"
    t.string   "overview_bullet_2"
    t.string   "overview_bullet_3"
    t.boolean  "published",                  :default => false, :null => false
    t.string   "features_1_title"
    t.string   "features_2_title"
    t.text     "features_2_text"
    t.string   "features_3_title"
    t.text     "features_3_text"
    t.string   "short_title"
    t.string   "phone_number"
    t.integer  "brochure_type",              :default => 0,     :null => false
    t.string   "brochure_link_text"
    t.string   "brochure_file_name"
    t.string   "brochure_content_type"
    t.string   "brochure_url"
    t.string   "cached_slug"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.boolean  "show_lead_2_lease",          :default => false, :null => false
    t.string   "lead_2_lease_email"
  end

  create_table "properties_property_features", :id => false, :force => true do |t|
    t.integer "property_id"
    t.integer "property_feature_id"
  end

  create_table "property_features", :force => true do |t|
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.string   "name"
    t.text     "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "property_mini_slides", :force => true do |t|
    t.string   "image_file_name",            :null => false
    t.string   "image_content_type",         :null => false
    t.integer  "position"
    t.integer  "property_mini_slideshow_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "property_mini_slideshows", :force => true do |t|
    t.string   "name",        :null => false
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "property_slides", :force => true do |t|
    t.string   "caption"
    t.string   "image_file_name",       :null => false
    t.string   "image_content_type",    :null => false
    t.integer  "position"
    t.integer  "property_slideshow_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "property_slideshows", :force => true do |t|
    t.string   "name",        :null => false
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", :force => true do |t|
    t.string   "title",                                             :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
    t.boolean  "service",                        :default => false, :null => false
    t.string   "left_montage_image_file_name"
    t.string   "middle_montage_image_file_name"
    t.string   "right_montage_image_file_name"
    t.boolean  "about",                          :default => false, :null => false
  end

  add_index "sections", ["about"], :name => "index_sections_on_about"
  add_index "sections", ["cached_slug"], :name => "index_sections_on_cached_slug"

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "states", :force => true do |t|
    t.string   "code",       :null => false
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "testimonials", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "quote",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "section_id"
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

  create_table "videos", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "url",                :null => false
    t.integer  "property_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
