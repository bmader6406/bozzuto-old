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

ActiveRecord::Schema.define(:version => 20111025180348) do

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
    t.integer  "bedrooms"
    t.decimal  "bathrooms",               :precision => 3, :scale => 1
    t.integer  "floor_plan_group_id",                                                      :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                                                                     :null => false
    t.string   "availability_url"
    t.integer  "min_square_feet"
    t.integer  "max_square_feet"
    t.decimal  "min_market_rent",         :precision => 8, :scale => 2
    t.decimal  "max_market_rent",         :precision => 8, :scale => 2
    t.decimal  "min_effective_rent",      :precision => 8, :scale => 2
    t.decimal  "max_effective_rent",      :precision => 8, :scale => 2
    t.integer  "apartment_community_id",                                                   :null => false
    t.decimal  "min_rent",                :precision => 8, :scale => 2
    t.decimal  "max_rent",                :precision => 8, :scale => 2
    t.integer  "image_type",                                            :default => 0,     :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "vaultware_floor_plan_id"
    t.integer  "vaultware_file_id"
    t.boolean  "featured",                                              :default => false, :null => false
    t.boolean  "rolled_up",                                             :default => false, :null => false
  end

  add_index "apartment_floor_plans", ["apartment_community_id"], :name => "index_apartment_floor_plans_on_apartment_community_id"
  add_index "apartment_floor_plans", ["floor_plan_group_id"], :name => "index_apartment_floor_plans_on_floor_plan_group_id"

  create_table "archived_pages", :id => false, :force => true do |t|
    t.integer  "id",                             :default => 0,     :null => false
    t.string   "title",                                             :null => false
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
    t.string   "left_montage_image_file_name"
    t.string   "middle_montage_image_file_name"
    t.string   "right_montage_image_file_name"
    t.boolean  "published",                      :default => false, :null => false
    t.datetime "deleted_at"
    t.text     "mobile_body"
    t.text     "mobile_body_extra"
    t.boolean  "show_sidebar",                   :default => true
  end

  add_index "archived_pages", ["cached_slug"], :name => "index_archived_pages_on_cached_slug"
  add_index "archived_pages", ["id"], :name => "index_archived_pages_on_id"

  create_table "archived_properties", :id => false, :force => true do |t|
    t.integer  "id",                           :default => 0,     :null => false
    t.string   "title",                                           :null => false
    t.string   "subtitle"
    t.integer  "city_id",                                         :null => false
    t.boolean  "elite",                        :default => false, :null => false
    t.boolean  "smart_share",                  :default => false, :null => false
    t.boolean  "smart_rent",                   :default => false, :null => false
    t.boolean  "green",                        :default => false, :null => false
    t.boolean  "non_smoking",                  :default => false, :null => false
    t.string   "website_url"
    t.string   "video_url"
    t.string   "facebook_url"
    t.string   "promo_image"
    t.string   "promo_url"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "street_address"
    t.text     "overview_text"
    t.text     "promotions_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "local_info_feed_id"
    t.integer  "vaultware_id"
    t.boolean  "use_market_prices",            :default => false, :null => false
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
    t.boolean  "published",                    :default => false, :null => false
    t.string   "short_title"
    t.string   "phone_number"
    t.integer  "brochure_type",                :default => 0,     :null => false
    t.string   "brochure_link_text"
    t.string   "brochure_file_name"
    t.string   "brochure_content_type"
    t.string   "brochure_url"
    t.string   "cached_slug"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.boolean  "show_lead_2_lease",            :default => false, :null => false
    t.string   "lead_2_lease_email"
    t.date     "completion_date"
    t.string   "media_meta_title"
    t.string   "media_meta_description"
    t.string   "media_meta_keywords"
    t.string   "floor_plans_meta_title"
    t.string   "floor_plans_meta_description"
    t.string   "floor_plans_meta_keywords"
    t.string   "promotions_meta_title"
    t.string   "promotions_meta_description"
    t.string   "promotions_meta_keywords"
    t.integer  "position"
    t.integer  "promo_id"
    t.integer  "ufollowup_id"
    t.boolean  "has_completion_date",          :default => true,  :null => false
    t.string   "cheapest_studio_price"
    t.string   "cheapest_1_bedroom_price"
    t.string   "cheapest_2_bedroom_price"
    t.string   "cheapest_3_bedroom_price"
    t.string   "cheapest_penthouse_price"
    t.string   "listing_promo_file_name"
    t.string   "listing_promo_content_type"
    t.integer  "listing_promo_file_size"
    t.string   "resident_link_text"
    t.string   "resident_link_url"
    t.boolean  "featured",                     :default => false, :null => false
    t.integer  "featured_position"
    t.datetime "deleted_at"
    t.string   "zip_code"
    t.string   "lead_2_lease_id"
    t.string   "mobile_phone_number"
    t.integer  "twitter_account_id"
    t.string   "send_to_friend_mediamind_id"
    t.string   "send_to_phone_mediamind_id"
    t.string   "contact_mediamind_id"
  end

  add_index "archived_properties", ["id"], :name => "index_archived_properties_on_id"

  create_table "assets", :force => true do |t|
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.string   "type",              :limit => 25
    t.integer  "typus_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["typus_user_id"], :name => "index_assets_on_typus_user_id"

  create_table "awards", :force => true do |t|
    t.string   "title",                                 :null => false
    t.text     "body"
    t.boolean  "published",          :default => false, :null => false
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
  end

  create_table "awards_sections", :id => false, :force => true do |t|
    t.integer "award_id"
    t.integer "section_id"
  end

  add_index "awards_sections", ["award_id", "section_id"], :name => "index_awards_sections_on_award_id_and_section_id"
  add_index "awards_sections", ["section_id", "award_id"], :name => "index_awards_sections_on_section_id_and_award_id"

  create_table "body_slides", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "body_slideshow_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link_url"
    t.integer  "property_id"
    t.string   "video_url"
  end

  add_index "body_slides", ["body_slideshow_id"], :name => "index_body_slides_on_body_slideshow_id"

  create_table "body_slideshows", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "body_slideshows", ["page_id"], :name => "index_body_slideshows_on_page_id"

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

  create_table "carousel_panels", :force => true do |t|
    t.integer  "position",           :null => false
    t.integer  "carousel_id",        :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "link_url",           :null => false
    t.string   "heading"
    t.string   "caption"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carousels", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "state_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["state_id"], :name => "index_cities_on_state_id"

  create_table "cities_counties", :id => false, :force => true do |t|
    t.integer "city_id"
    t.integer "county_id"
  end

  create_table "contact_topics", :force => true do |t|
    t.string   "topic",      :null => false
    t.text     "body"
    t.string   "recipients", :null => false
    t.integer  "section_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversion_configurations", :force => true do |t|
    t.string   "name"
    t.string   "google_send_to_friend_label"
    t.string   "google_send_to_phone_label"
    t.string   "google_contact_label"
    t.string   "bing_send_to_friend_action_id"
    t.string   "bing_send_to_phone_action_id"
    t.string   "bing_contact_action_id"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "counties", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "state_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "counties", ["state_id"], :name => "index_counties_on_state_id"

  create_table "dnr_configurations", :force => true do |t|
    t.string   "customer_code"
    t.string   "campaign"
    t.string   "ad_source"
    t.integer  "property_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dnr_referrers", :force => true do |t|
    t.string   "domain_name", :null => false
    t.string   "pattern",     :null => false
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.integer  "mini_slideshow_id"
    t.string   "mobile_title"
    t.string   "mobile_banner_image_file_name"
    t.string   "mobile_banner_image_content_type"
    t.text     "mobile_body"
    t.integer  "twitter_account_id"
  end

  add_index "home_pages", ["mini_slideshow_id"], :name => "index_home_pages_on_mini_slideshow_id"

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

  create_table "landing_page_popular_properties", :force => true do |t|
    t.integer "landing_page_id"
    t.integer "property_id"
    t.integer "position"
  end

  create_table "landing_pages", :force => true do |t|
    t.string   "title",                                             :null => false
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.string   "cached_slug"
    t.integer  "state_id",                                          :null => false
    t.text     "masthead_body"
    t.string   "masthead_image_file_name"
    t.string   "masthead_image_content_type"
    t.string   "secondary_title"
    t.text     "secondary_body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "promo_id"
    t.boolean  "custom_sort_popular_properties", :default => false, :null => false
    t.boolean  "published",                      :default => false, :null => false
    t.boolean  "hide_from_list",                 :default => false, :null => false
    t.boolean  "randomize_property_listings"
    t.integer  "local_info_feed_id"
    t.boolean  "show_apartments_by_area",        :default => true
    t.string   "masthead_image_url"
  end

  create_table "landing_pages_projects", :id => false, :force => true do |t|
    t.integer "landing_page_id"
    t.integer "project_id"
  end

  add_index "landing_pages_projects", ["landing_page_id", "project_id"], :name => "index_landing_pages_projects_on_landing_page_id_and_project_id"

  create_table "lasso_accounts", :force => true do |t|
    t.integer  "property_id",  :null => false
    t.string   "uid",          :null => false
    t.string   "client_id",    :null => false
    t.string   "project_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "analytics_id"
  end

  add_index "lasso_accounts", ["property_id"], :name => "index_lasso_accounts_on_property_id"

  create_table "leaders", :force => true do |t|
    t.string   "name",                :null => false
    t.string   "title",               :null => false
    t.string   "company",             :null => false
    t.integer  "leadership_group_id", :null => false
    t.text     "bio",                 :null => false
    t.integer  "position"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
  end

  add_index "leaders", ["cached_slug"], :name => "index_leaders_on_cached_slug"

  create_table "leadership_groups", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "masthead_slides", :force => true do |t|
    t.text     "body",                                 :null => false
    t.integer  "slide_type",            :default => 0, :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_link"
    t.text     "sidebar_text"
    t.integer  "masthead_slideshow_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mini_slideshow_id"
    t.text     "quote"
    t.string   "quote_attribution"
    t.string   "quote_job_title"
    t.string   "quote_company"
  end

  add_index "masthead_slides", ["masthead_slideshow_id"], :name => "index_masthead_slides_on_masthead_slideshow_id"
  add_index "masthead_slides", ["mini_slideshow_id"], :name => "index_masthead_slides_on_mini_slideshow_id"

  create_table "masthead_slideshows", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "masthead_slideshows", ["page_id"], :name => "index_masthead_slideshows_on_page_id"

  create_table "mini_slides", :force => true do |t|
    t.string   "image_file_name",    :null => false
    t.string   "image_content_type", :null => false
    t.integer  "position"
    t.integer  "mini_slideshow_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mini_slides", ["mini_slideshow_id"], :name => "index_mini_slides_on_mini_slideshow_id"

  create_table "mini_slideshows", :force => true do |t|
    t.string   "title",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subtitle"
    t.string   "link_url"
  end

  create_table "news_posts", :force => true do |t|
    t.string   "title",                                 :null => false
    t.text     "body"
    t.boolean  "published",          :default => false, :null => false
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.string   "image_file_name"
    t.string   "image_content_type"
  end

  create_table "news_posts_sections", :id => false, :force => true do |t|
    t.integer "news_post_id"
    t.integer "section_id"
  end

  add_index "news_posts_sections", ["news_post_id", "section_id"], :name => "index_news_posts_sections_on_news_post_id_and_section_id"
  add_index "news_posts_sections", ["section_id", "news_post_id"], :name => "index_news_posts_sections_on_section_id_and_news_post_id"

  create_table "pages", :force => true do |t|
    t.string   "title",                                             :null => false
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
    t.string   "left_montage_image_file_name"
    t.string   "middle_montage_image_file_name"
    t.string   "right_montage_image_file_name"
    t.boolean  "published",                      :default => false, :null => false
    t.text     "mobile_body"
    t.text     "mobile_body_extra"
    t.boolean  "show_sidebar",                   :default => true
  end

  add_index "pages", ["path"], :name => "index_pages_on_path"
  add_index "pages", ["section_id"], :name => "index_pages_on_section_id"

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

  add_index "photo_groups_photos", ["photo_group_id"], :name => "index_photo_groups_photos_on_photo_group_id"
  add_index "photo_groups_photos", ["photo_id"], :name => "index_photo_groups_photos_on_photo_id"

  create_table "photo_sets", :force => true do |t|
    t.string   "title",                                :null => false
    t.string   "flickr_set_number",                    :null => false
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "needs_sync",        :default => false, :null => false
  end

  add_index "photo_sets", ["property_id"], :name => "index_photo_sets_on_property_id"

  create_table "photos", :force => true do |t|
    t.string   "image_file_name",    :default => ""
    t.string   "title",              :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_content_type"
    t.string   "flickr_photo_id",                    :null => false
    t.integer  "photo_set_id"
    t.integer  "position"
  end

  add_index "photos", ["photo_set_id"], :name => "index_photos_on_photo_set_id"

  create_table "press_releases", :force => true do |t|
    t.string   "title",                               :null => false
    t.text     "body"
    t.boolean  "published",        :default => false, :null => false
    t.datetime "published_at"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "press_releases_sections", :id => false, :force => true do |t|
    t.integer "press_release_id"
    t.integer "section_id"
  end

  add_index "press_releases_sections", ["press_release_id", "section_id"], :name => "index_press_releases_sections_on_press_release_id_and_section_id"
  add_index "press_releases_sections", ["section_id", "press_release_id"], :name => "index_press_releases_sections_on_section_id_and_press_release_id"

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
    t.text     "body",                                  :null => false
    t.integer  "project_id",                            :null => false
    t.boolean  "published",          :default => false, :null => false
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.string   "image_title"
    t.string   "image_description"
  end

  create_table "promos", :force => true do |t|
    t.string   "title",                                  :null => false
    t.string   "subtitle"
    t.string   "link_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_expiration_date", :default => false
    t.datetime "expiration_date"
  end

  create_table "properties", :force => true do |t|
    t.string   "title",                                           :null => false
    t.string   "subtitle"
    t.integer  "city_id",                                         :null => false
    t.boolean  "elite",                        :default => false, :null => false
    t.boolean  "smart_share",                  :default => false, :null => false
    t.boolean  "smart_rent",                   :default => false, :null => false
    t.boolean  "green",                        :default => false, :null => false
    t.boolean  "non_smoking",                  :default => false, :null => false
    t.string   "website_url"
    t.string   "video_url"
    t.string   "facebook_url"
    t.string   "promo_image"
    t.string   "promo_url"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "street_address"
    t.text     "overview_text"
    t.text     "promotions_text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "local_info_feed_id"
    t.integer  "vaultware_id"
    t.boolean  "use_market_prices",            :default => false, :null => false
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
    t.boolean  "published",                    :default => false, :null => false
    t.string   "short_title"
    t.string   "phone_number"
    t.integer  "brochure_type",                :default => 0,     :null => false
    t.string   "brochure_link_text"
    t.string   "brochure_file_name"
    t.string   "brochure_content_type"
    t.string   "brochure_url"
    t.string   "cached_slug"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.boolean  "show_lead_2_lease",            :default => false, :null => false
    t.string   "lead_2_lease_email"
    t.date     "completion_date"
    t.string   "media_meta_title"
    t.string   "media_meta_description"
    t.string   "media_meta_keywords"
    t.string   "floor_plans_meta_title"
    t.string   "floor_plans_meta_description"
    t.string   "floor_plans_meta_keywords"
    t.string   "promotions_meta_title"
    t.string   "promotions_meta_description"
    t.string   "promotions_meta_keywords"
    t.integer  "position"
    t.integer  "promo_id"
    t.integer  "ufollowup_id"
    t.boolean  "has_completion_date",          :default => true,  :null => false
    t.string   "cheapest_studio_price"
    t.string   "cheapest_1_bedroom_price"
    t.string   "cheapest_2_bedroom_price"
    t.string   "cheapest_3_bedroom_price"
    t.string   "cheapest_penthouse_price"
    t.string   "listing_promo_file_name"
    t.string   "listing_promo_content_type"
    t.integer  "listing_promo_file_size"
    t.string   "resident_link_text"
    t.string   "resident_link_url"
    t.boolean  "featured",                     :default => false, :null => false
    t.integer  "featured_position"
    t.string   "zip_code"
    t.string   "lead_2_lease_id"
    t.string   "mobile_phone_number"
    t.integer  "twitter_account_id"
    t.string   "send_to_friend_mediamind_id"
    t.string   "send_to_phone_mediamind_id"
    t.string   "contact_mediamind_id"
  end

  create_table "properties_property_features", :id => false, :force => true do |t|
    t.integer "property_id"
    t.integer "property_feature_id"
  end

  add_index "properties_property_features", ["property_id"], :name => "index_properties_property_features_on_property_id"

  create_table "property_contact_pages", :force => true do |t|
    t.integer  "property_id",      :null => false
    t.text     "content"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "property_contact_pages", ["property_id"], :name => "index_property_contact_pages_on_property_id"

  create_table "property_features", :force => true do |t|
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.string   "name"
    t.text     "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_on_search_page", :default => false, :null => false
  end

  create_table "property_features_pages", :force => true do |t|
    t.integer  "property_id",      :null => false
    t.text     "text_1"
    t.string   "title_1"
    t.string   "title_2"
    t.text     "text_2"
    t.string   "title_3"
    t.text     "text_3"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "property_features_pages", ["property_id"], :name => "index_property_features_pages_on_property_id"

  create_table "property_neighborhood_pages", :force => true do |t|
    t.integer  "property_id",      :null => false
    t.text     "content"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "property_neighborhood_pages", ["property_id"], :name => "index_property_neighborhood_pages_on_property_id"

  create_table "property_slides", :force => true do |t|
    t.string   "caption"
    t.string   "image_file_name",       :null => false
    t.string   "image_content_type",    :null => false
    t.integer  "position"
    t.integer  "property_slideshow_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "property_slides", ["property_slideshow_id"], :name => "index_property_slides_on_property_slideshow_id"

  create_table "property_slideshows", :force => true do |t|
    t.string   "name",        :null => false
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "property_slideshows", ["property_id"], :name => "index_property_slideshows_on_property_id"

  create_table "publications", :force => true do |t|
    t.string   "name",                                  :null => false
    t.text     "description"
    t.integer  "position"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.boolean  "published",          :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "publications", ["published", "position"], :name => "index_publications_on_published_and_position"

  create_table "rank_categories", :force => true do |t|
    t.string   "name",           :null => false
    t.integer  "position"
    t.integer  "publication_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rank_categories", ["publication_id", "position"], :name => "index_rank_categories_on_publication_id_and_position"

  create_table "ranks", :force => true do |t|
    t.integer  "rank_number",      :null => false
    t.integer  "year",             :null => false
    t.string   "description"
    t.integer  "rank_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ranks", ["rank_category_id", "year"], :name => "index_ranks_on_rank_category_id_and_year"

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

  create_table "snippets", :force => true do |t|
    t.string   "name",       :null => false
    t.text     "body",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", :force => true do |t|
    t.string   "code",       :null => false
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "testimonials", :force => true do |t|
    t.string   "name",       :default => ""
    t.string   "title",      :default => ""
    t.text     "quote",                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "section_id"
  end

  create_table "tweets", :force => true do |t|
    t.string   "tweet_id",           :null => false
    t.text     "text",               :null => false
    t.datetime "posted_at",          :null => false
    t.integer  "twitter_account_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tweets", ["tweet_id"], :name => "index_tweets_on_tweet_id"
  add_index "tweets", ["twitter_account_id"], :name => "index_tweets_on_twitter_account_id"

  create_table "twitter_accounts", :force => true do |t|
    t.string   "username",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "twitter_accounts", ["username"], :name => "index_twitter_accounts_on_username"

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
