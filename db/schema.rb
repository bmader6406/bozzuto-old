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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160321193058) do

  create_table "ad_sources", force: :cascade do |t|
    t.string   "domain_name", limit: 255, null: false
    t.string   "pattern",     limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "value",       limit: 255, null: false
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "name",                   limit: 255
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "apartment_communities", force: :cascade do |t|
    t.string   "title",                                   limit: 255,                                            null: false
    t.string   "short_title",                             limit: 255
    t.string   "short_description",                       limit: 255
    t.string   "subtitle",                                limit: 255
    t.string   "street_address",                          limit: 255
    t.string   "zip_code",                                limit: 255
    t.decimal  "latitude",                                              precision: 10, scale: 6
    t.decimal  "longitude",                                             precision: 10, scale: 6
    t.string   "website_url",                             limit: 255
    t.string   "website_url_text",                        limit: 255
    t.string   "video_url",                               limit: 255
    t.string   "promo_image",                             limit: 255
    t.string   "promo_url",                               limit: 255
    t.text     "promotions_text",                         limit: 65535
    t.text     "overview_text",                           limit: 65535
    t.string   "availability_url",                        limit: 255
    t.string   "listing_title",                           limit: 255
    t.text     "listing_text",                            limit: 65535
    t.string   "overview_title",                          limit: 255
    t.string   "overview_bullet_1",                       limit: 255
    t.string   "overview_bullet_2",                       limit: 255
    t.string   "overview_bullet_3",                       limit: 255
    t.integer  "brochure_type",                           limit: 4,                              default: 0,     null: false
    t.string   "brochure_link_text",                      limit: 255
    t.string   "brochure_url",                            limit: 255
    t.string   "resident_link_text",                      limit: 255
    t.string   "resident_link_url",                       limit: 255
    t.text     "office_hours",                            limit: 65535
    t.string   "schedule_tour_url",                       limit: 255
    t.text     "neighborhood_description",                limit: 65535
    t.string   "page_header",                             limit: 255
    t.boolean  "published",                                                                      default: false, null: false
    t.boolean  "featured",                                                                       default: false, null: false
    t.boolean  "elite",                                                                          default: false, null: false
    t.boolean  "smart_share",                                                                    default: false, null: false
    t.boolean  "smart_rent",                                                                     default: false, null: false
    t.boolean  "green",                                                                          default: false, null: false
    t.boolean  "non_smoking",                                                                    default: false, null: false
    t.boolean  "show_lead_2_lease",                                                              default: false, null: false
    t.boolean  "featured_mobile",                                                                default: false, null: false
    t.boolean  "under_construction",                                                             default: false, null: false
    t.boolean  "show_rtrk_code",                                                                 default: false, null: false
    t.string   "meta_title",                              limit: 255
    t.string   "meta_description",                        limit: 255
    t.string   "meta_keywords",                           limit: 255
    t.string   "media_meta_title",                        limit: 255
    t.string   "media_meta_description",                  limit: 255
    t.string   "media_meta_keywords",                     limit: 255
    t.string   "floor_plans_meta_title",                  limit: 255
    t.string   "floor_plans_meta_description",            limit: 255
    t.string   "floor_plans_meta_keywords",               limit: 255
    t.string   "promotions_meta_title",                   limit: 255
    t.string   "promotions_meta_description",             limit: 255
    t.string   "promotions_meta_keywords",                limit: 255
    t.string   "seo_link_url",                            limit: 255
    t.string   "seo_link_text",                           limit: 255
    t.string   "slug",                                    limit: 255
    t.integer  "position",                                limit: 4
    t.integer  "featured_position",                       limit: 4
    t.string   "listing_image_file_name",                 limit: 255
    t.string   "listing_image_content_type",              limit: 255
    t.string   "brochure_file_name",                      limit: 255
    t.string   "brochure_content_type",                   limit: 255
    t.string   "hero_image_file_name",                    limit: 255
    t.string   "hero_image_content_type",                 limit: 255
    t.string   "hero_image_file_size",                    limit: 255
    t.string   "neighborhood_listing_image_file_name",    limit: 255
    t.string   "neighborhood_listing_image_content_type", limit: 255
    t.string   "phone_number",                            limit: 255
    t.string   "mobile_phone_number",                     limit: 255
    t.string   "lead_2_lease_email",                      limit: 255
    t.string   "lead_2_lease_id",                         limit: 255
    t.string   "external_cms_id",                         limit: 255
    t.string   "external_cms_type",                       limit: 255
    t.string   "external_management_id",                  limit: 255
    t.integer  "core_id",                                 limit: 4
    t.integer  "unit_count",                              limit: 4
    t.boolean  "included_in_export",                                                             default: true,  null: false
    t.boolean  "found_in_latest_feed",                                                           default: true,  null: false
    t.string   "facebook_url",                            limit: 255
    t.string   "pinterest_url",                           limit: 255
    t.integer  "ufollowup_id",                            limit: 4
    t.string   "send_to_friend_mediamind_id",             limit: 255
    t.string   "send_to_phone_mediamind_id",              limit: 255
    t.string   "contact_mediamind_id",                    limit: 255
    t.string   "hyly_id",                                 limit: 255
    t.integer  "city_id",                                 limit: 4
    t.integer  "county_id",                               limit: 4
    t.integer  "local_info_feed_id",                      limit: 4
    t.integer  "promo_id",                                limit: 4
    t.integer  "twitter_account_id",                      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apartment_communities", ["core_id"], name: "index_apartment_communities_on_core_id", using: :btree
  add_index "apartment_communities", ["external_cms_id", "external_cms_type"], name: "index_apt_communities_on_external_cms_id_and_type", unique: true, using: :btree
  add_index "apartment_communities", ["slug"], name: "index_apartment_communities_on_slug", using: :btree

  create_table "apartment_communities_landing_pages", id: false, force: :cascade do |t|
    t.integer "landing_page_id",        limit: 4
    t.integer "apartment_community_id", limit: 4
  end

  create_table "apartment_contact_configurations", force: :cascade do |t|
    t.integer  "apartment_community_id",  limit: 4,        null: false
    t.text     "upcoming_intro_text",     limit: 16777215
    t.text     "upcoming_thank_you_text", limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apartment_contact_configurations", ["apartment_community_id"], name: "index_apartment_contact_configurations_on_apartment_community_id", using: :btree

  create_table "apartment_floor_plan_caches", force: :cascade do |t|
    t.integer  "cacheable_id",             limit: 4,                                         null: false
    t.string   "cacheable_type",           limit: 255,                                       null: false
    t.decimal  "studio_min_price",                     precision: 8, scale: 2, default: 0.0
    t.integer  "studio_count",             limit: 4,                           default: 0
    t.decimal  "one_bedroom_min_price",                precision: 8, scale: 2, default: 0.0
    t.integer  "one_bedroom_count",        limit: 4,                           default: 0
    t.decimal  "two_bedrooms_min_price",               precision: 8, scale: 2, default: 0.0
    t.integer  "two_bedrooms_count",       limit: 4,                           default: 0
    t.decimal  "three_bedrooms_min_price",             precision: 8, scale: 2, default: 0.0
    t.integer  "three_bedrooms_count",     limit: 4,                           default: 0
    t.decimal  "penthouse_min_price",                  precision: 8, scale: 2, default: 0.0
    t.integer  "penthouse_count",          limit: 4,                           default: 0
    t.decimal  "min_price",                            precision: 8, scale: 2, default: 0.0
    t.decimal  "max_price",                            precision: 8, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apartment_floor_plan_groups", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "position",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apartment_floor_plans", force: :cascade do |t|
    t.string   "image_url",              limit: 255
    t.integer  "bedrooms",               limit: 4
    t.decimal  "bathrooms",                          precision: 3, scale: 1
    t.integer  "floor_plan_group_id",    limit: 4,                                           null: false
    t.integer  "position",               limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255,                                         null: false
    t.string   "availability_url",       limit: 255
    t.integer  "min_square_feet",        limit: 4
    t.integer  "max_square_feet",        limit: 4
    t.integer  "apartment_community_id", limit: 4,                                           null: false
    t.decimal  "min_rent",                           precision: 8, scale: 2
    t.decimal  "max_rent",                           precision: 8, scale: 2
    t.integer  "image_type",             limit: 4,                           default: 0,     null: false
    t.string   "image_file_name",        limit: 255
    t.string   "image_content_type",     limit: 255
    t.string   "external_cms_id",        limit: 255
    t.boolean  "featured",                                                   default: false, null: false
    t.string   "external_cms_type",      limit: 255
    t.integer  "available_units",        limit: 4,                           default: 0
    t.integer  "unit_count",             limit: 4
  end

  add_index "apartment_floor_plans", ["apartment_community_id"], name: "index_apartment_floor_plans_on_apartment_community_id", using: :btree
  add_index "apartment_floor_plans", ["external_cms_id"], name: "index_apartment_floor_plans_on_external_cms_id", using: :btree
  add_index "apartment_floor_plans", ["floor_plan_group_id"], name: "index_apartment_floor_plans_on_floor_plan_group_id", using: :btree

  create_table "apartment_unit_amenities", force: :cascade do |t|
    t.integer  "apartment_unit_id", limit: 4,                     null: false
    t.string   "primary_type",      limit: 255, default: "Other", null: false
    t.string   "sub_type",          limit: 255
    t.string   "description",       limit: 255
    t.integer  "rank",              limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apartment_unit_amenities", ["apartment_unit_id"], name: "index_apartment_unit_amenities_on_apartment_unit_id", using: :btree

  create_table "apartment_units", force: :cascade do |t|
    t.string   "external_cms_id",              limit: 255
    t.string   "external_cms_type",            limit: 255
    t.string   "building_external_cms_id",     limit: 255
    t.string   "floorplan_external_cms_id",    limit: 255
    t.string   "organization_name",            limit: 255
    t.string   "marketing_name",               limit: 255
    t.string   "unit_type",                    limit: 255
    t.decimal  "bedrooms",                                   precision: 3, scale: 1
    t.decimal  "bathrooms",                                  precision: 3, scale: 1
    t.integer  "min_square_feet",              limit: 4
    t.integer  "max_square_feet",              limit: 4
    t.string   "square_foot_type",             limit: 255
    t.decimal  "unit_rent",                                  precision: 8, scale: 2
    t.decimal  "market_rent",                                precision: 8, scale: 2
    t.string   "economic_status",              limit: 255
    t.string   "economic_status_description",  limit: 255
    t.string   "occupancy_status",             limit: 255
    t.string   "occupancy_status_description", limit: 255
    t.string   "leased_status",                limit: 255
    t.string   "leased_status_description",    limit: 255
    t.integer  "number_occupants",             limit: 4
    t.string   "floor_plan_name",              limit: 255
    t.string   "phase_name",                   limit: 255
    t.string   "building_name",                limit: 255
    t.string   "primary_property_id",          limit: 255
    t.string   "address_line_1",               limit: 255
    t.string   "address_line_2",               limit: 255
    t.string   "city",                         limit: 255
    t.string   "state",                        limit: 255
    t.string   "zip",                          limit: 255
    t.string   "comment",                      limit: 255
    t.decimal  "min_rent",                                   precision: 8, scale: 2
    t.decimal  "max_rent",                                   precision: 8, scale: 2
    t.decimal  "avg_rent",                                   precision: 8, scale: 2
    t.date     "vacate_date"
    t.string   "vacancy_class",                limit: 255
    t.date     "made_ready_date"
    t.text     "availability_url",             limit: 65535
    t.integer  "floor_plan_id",                limit: 4,                                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "include_in_export",                                                  default: true, null: false
  end

  create_table "area_memberships", force: :cascade do |t|
    t.integer  "area_id",                limit: 4,             null: false
    t.integer  "apartment_community_id", limit: 4,             null: false
    t.integer  "position",               limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tier",                   limit: 4, default: 2, null: false
  end

  add_index "area_memberships", ["area_id"], name: "index_area_memberships_on_area_id", using: :btree
  add_index "area_memberships", ["tier"], name: "index_area_memberships_on_tier", using: :btree

  create_table "areas", force: :cascade do |t|
    t.string   "name",                    limit: 255,                                                      null: false
    t.string   "slug",                    limit: 255
    t.decimal  "latitude",                              precision: 10, scale: 6,                           null: false
    t.decimal  "longitude",                             precision: 10, scale: 6,                           null: false
    t.integer  "metro_id",                limit: 4,                                                        null: false
    t.integer  "position",                limit: 4
    t.string   "banner_image_file_name",  limit: 255
    t.string   "listing_image_file_name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description",             limit: 65535
    t.text     "detail_description",      limit: 65535
    t.integer  "state_id",                limit: 4
    t.string   "area_type",               limit: 255,                            default: "neighborhoods", null: false
  end

  add_index "areas", ["metro_id"], name: "index_areas_on_metro_id", using: :btree
  add_index "areas", ["name"], name: "index_areas_on_name", unique: true, using: :btree
  add_index "areas", ["slug"], name: "index_areas_on_slug", using: :btree

  create_table "awards", force: :cascade do |t|
    t.string   "title",                        limit: 255,                   null: false
    t.text     "body",                         limit: 65535
    t.boolean  "published",                                  default: false, null: false
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",              limit: 255
    t.string   "image_content_type",           limit: 255
    t.boolean  "featured",                                   default: false
    t.boolean  "show_as_featured_news",                      default: false, null: false
    t.string   "home_page_image_file_name",    limit: 255
    t.string   "home_page_image_content_type", limit: 255
  end

  create_table "awards_sections", id: false, force: :cascade do |t|
    t.integer "award_id",   limit: 4
    t.integer "section_id", limit: 4
  end

  add_index "awards_sections", ["award_id", "section_id"], name: "index_awards_sections_on_award_id_and_section_id", using: :btree
  add_index "awards_sections", ["section_id", "award_id"], name: "index_awards_sections_on_section_id_and_award_id", using: :btree

  create_table "body_slides", force: :cascade do |t|
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "body_slideshow_id",  limit: 4
    t.integer  "position",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link_url",           limit: 255
    t.integer  "property_id",        limit: 4
    t.string   "video_url",          limit: 255
    t.string   "property_type",      limit: 255
  end

  add_index "body_slides", ["body_slideshow_id"], name: "index_body_slides_on_body_slideshow_id", using: :btree

  create_table "body_slideshows", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "page_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "body_slideshows", ["page_id"], name: "index_body_slideshows_on_page_id", using: :btree

  create_table "bozzuto_blog_posts", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.string   "url",                limit: 255
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "header_title",       limit: 255
    t.string   "header_url",         limit: 255
  end

  add_index "bozzuto_blog_posts", ["published_at"], name: "index_bozzuto_blog_posts_on_published_at", using: :btree

  create_table "buzzes", force: :cascade do |t|
    t.string   "email",        limit: 255, null: false
    t.string   "first_name",   limit: 255
    t.string   "last_name",    limit: 255
    t.string   "street1",      limit: 255
    t.string   "street2",      limit: 255
    t.string   "city",         limit: 255
    t.string   "state",        limit: 255
    t.string   "zip_code",     limit: 255
    t.string   "phone",        limit: 255
    t.string   "buzzes",       limit: 255
    t.string   "affiliations", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "careers_entries", force: :cascade do |t|
    t.string   "name",                    limit: 255,      null: false
    t.string   "company",                 limit: 255,      null: false
    t.string   "job_title",               limit: 255,      null: false
    t.text     "job_description",         limit: 16777215
    t.string   "main_photo_file_name",    limit: 255
    t.string   "main_photo_content_type", limit: 255
    t.string   "headshot_file_name",      limit: 255
    t.string   "headshot_content_type",   limit: 255
    t.string   "youtube_url",             limit: 255
    t.integer  "position",                limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "careers_entries", ["position"], name: "index_careers_entries_on_position", using: :btree

  create_table "carousel_panels", force: :cascade do |t|
    t.integer  "position",           limit: 4,                   null: false
    t.integer  "carousel_id",        limit: 4,                   null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.string   "link_url",           limit: 255,                 null: false
    t.string   "heading",            limit: 255
    t.string   "caption",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "featured",                       default: false
  end

  create_table "carousels", force: :cascade do |t|
    t.string   "name",         limit: 255, null: false
    t.integer  "content_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_type", limit: 255
  end

  add_index "carousels", ["content_type", "content_id"], name: "index_carousels_on_content_type_and_content_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "state_id",   limit: 4,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["state_id"], name: "index_cities_on_state_id", using: :btree

  create_table "cities_counties", id: false, force: :cascade do |t|
    t.integer "city_id",   limit: 4
    t.integer "county_id", limit: 4
  end

  create_table "contact_topics", force: :cascade do |t|
    t.string   "topic",      limit: 255,      null: false
    t.text     "body",       limit: 16777215
    t.string   "recipients", limit: 255,      null: false
    t.integer  "section_id", limit: 4
    t.integer  "position",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversion_configurations", force: :cascade do |t|
    t.string   "name",                          limit: 255
    t.string   "google_send_to_friend_label",   limit: 255
    t.string   "google_send_to_phone_label",    limit: 255
    t.string   "google_contact_label",          limit: 255
    t.string   "bing_send_to_friend_action_id", limit: 255
    t.string   "bing_send_to_phone_action_id",  limit: 255
    t.string   "bing_contact_action_id",        limit: 255
    t.integer  "property_id",                   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "counties", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "state_id",   limit: 4,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "counties", ["state_id"], name: "index_counties_on_state_id", using: :btree

  create_table "dnr_configurations", force: :cascade do |t|
    t.string   "customer_code", limit: 255
    t.string   "campaign",      limit: 255
    t.string   "ad_source",     limit: 255
    t.integer  "property_id",   limit: 4,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "property_type", limit: 255
  end

  create_table "featured_apartment_communities_landing_pages", id: false, force: :cascade do |t|
    t.integer "landing_page_id",        limit: 4
    t.integer "apartment_community_id", limit: 4
  end

  create_table "feed_files", force: :cascade do |t|
    t.integer  "feed_record_id",    limit: 4,                       null: false
    t.string   "feed_record_type",  limit: 255,                     null: false
    t.string   "external_cms_id",   limit: 255,                     null: false
    t.string   "external_cms_type", limit: 255,                     null: false
    t.boolean  "active",                          default: true,    null: false
    t.string   "file_type",         limit: 255,   default: "Other", null: false
    t.string   "description",       limit: 255
    t.string   "name",              limit: 255,                     null: false
    t.text     "caption",           limit: 65535
    t.string   "format",            limit: 255,                     null: false
    t.text     "source",            limit: 65535,                   null: false
    t.integer  "width",             limit: 4
    t.integer  "height",            limit: 4
    t.string   "rank",              limit: 255
    t.string   "ad_id",             limit: 255
    t.string   "affiliate_id",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_files", ["feed_record_id", "feed_record_type"], name: "index_feed_files_on_feed_record_id_and_feed_record_type", using: :btree

  create_table "file_uploads", force: :cascade do |t|
    t.string   "file_file_name",    limit: 255
    t.string   "file_content_type", limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255
    t.integer  "sluggable_id",   limit: 4
    t.integer  "sequence",       limit: 4,   default: 1, null: false
    t.string   "sluggable_type", limit: 40
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "sequence", "scope"], name: "index_slugs_on_n_s_s_and_s", unique: true, using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree

  create_table "green_features", force: :cascade do |t|
    t.string   "title",              limit: 255,      null: false
    t.text     "description",        limit: 16777215
    t.string   "photo_file_name",    limit: 255,      null: false
    t.string   "photo_content_type", limit: 255,      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "green_package_items", force: :cascade do |t|
    t.integer  "green_package_id", limit: 4,                                         null: false
    t.integer  "green_feature_id", limit: 4,                                         null: false
    t.decimal  "savings",                    precision: 8, scale: 2, default: 0.0,   null: false
    t.boolean  "ultra_green",                                        default: false, null: false
    t.integer  "x",                limit: 4,                         default: 0
    t.integer  "y",                limit: 4,                         default: 0
    t.integer  "position",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "green_package_items", ["green_package_id"], name: "index_green_package_items_on_green_package_id", using: :btree

  create_table "green_packages", force: :cascade do |t|
    t.integer  "home_community_id",  limit: 4,                                              null: false
    t.string   "photo_file_name",    limit: 255,                                            null: false
    t.string   "photo_content_type", limit: 255,                                            null: false
    t.decimal  "ten_year_old_cost",                   precision: 8, scale: 2, default: 0.0, null: false
    t.string   "graph_title",        limit: 255
    t.text     "graph_tooltip",      limit: 16777215
    t.string   "graph_file_name",    limit: 255
    t.string   "graph_content_type", limit: 255
    t.text     "disclaimer",         limit: 16777215,                                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "green_packages", ["home_community_id"], name: "index_green_packages_on_home_community_id", unique: true, using: :btree

  create_table "home_communities", force: :cascade do |t|
    t.string   "title",                                   limit: 255,                                            null: false
    t.string   "short_title",                             limit: 255
    t.string   "street_address",                          limit: 255
    t.string   "zip_code",                                limit: 255
    t.decimal  "latitude",                                              precision: 10, scale: 6
    t.decimal  "longitude",                                             precision: 10, scale: 6
    t.string   "website_url",                             limit: 255
    t.string   "website_url_text",                        limit: 255
    t.string   "video_url",                               limit: 255
    t.string   "availability_url",                        limit: 255
    t.string   "listing_title",                           limit: 255
    t.text     "listing_text",                            limit: 65535
    t.string   "overview_title",                          limit: 255
    t.text     "overview_text",                           limit: 65535
    t.string   "overview_bullet_1",                       limit: 255
    t.string   "overview_bullet_2",                       limit: 255
    t.string   "overview_bullet_3",                       limit: 255
    t.integer  "brochure_type",                           limit: 4,                              default: 0,     null: false
    t.string   "brochure_link_text",                      limit: 255
    t.string   "brochure_url",                            limit: 255
    t.text     "neighborhood_description",                limit: 65535
    t.boolean  "published",                                                                      default: false, null: false
    t.boolean  "show_rtrk_code",                                                                 default: false, null: false
    t.string   "meta_title",                              limit: 255
    t.string   "meta_description",                        limit: 255
    t.string   "meta_keywords",                           limit: 255
    t.string   "media_meta_title",                        limit: 255
    t.string   "media_meta_description",                  limit: 255
    t.string   "media_meta_keywords",                     limit: 255
    t.string   "floor_plans_meta_title",                  limit: 255
    t.string   "floor_plans_meta_description",            limit: 255
    t.string   "floor_plans_meta_keywords",               limit: 255
    t.string   "slug",                                    limit: 255
    t.integer  "position",                                limit: 4
    t.string   "listing_image_file_name",                 limit: 255
    t.string   "listing_image_content_type",              limit: 255
    t.string   "listing_promo_file_name",                 limit: 255
    t.string   "listing_promo_content_type",              limit: 255
    t.integer  "listing_promo_file_size",                 limit: 4
    t.string   "brochure_file_name",                      limit: 255
    t.string   "brochure_content_type",                   limit: 255
    t.string   "neighborhood_listing_image_file_name",    limit: 255
    t.string   "neighborhood_listing_image_content_type", limit: 255
    t.string   "phone_number",                            limit: 255
    t.string   "mobile_phone_number",                     limit: 255
    t.string   "facebook_url",                            limit: 255
    t.integer  "ufollowup_id",                            limit: 4
    t.integer  "secondary_lead_source_id",                limit: 4
    t.integer  "city_id",                                 limit: 4
    t.integer  "county_id",                               limit: 4
    t.integer  "local_info_feed_id",                      limit: 4
    t.integer  "promo_id",                                limit: 4
    t.integer  "twitter_account_id",                      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "home_communities", ["slug"], name: "index_home_communities_on_slug", using: :btree

  create_table "home_communities_landing_pages", id: false, force: :cascade do |t|
    t.integer "landing_page_id",   limit: 4
    t.integer "home_community_id", limit: 4
  end

  create_table "home_floor_plans", force: :cascade do |t|
    t.string   "name",               limit: 255, null: false
    t.string   "image_file_name",    limit: 255, null: false
    t.integer  "home_id",            limit: 4,   null: false
    t.string   "image_content_type", limit: 255
    t.integer  "position",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "home_neighborhood_memberships", force: :cascade do |t|
    t.integer  "home_neighborhood_id", limit: 4, null: false
    t.integer  "home_community_id",    limit: 4, null: false
    t.integer  "position",             limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "home_neighborhood_memberships", ["home_neighborhood_id"], name: "index_home_neighborhood_memberships_on_home_neighborhood_id", using: :btree

  create_table "home_neighborhoods", force: :cascade do |t|
    t.string   "name",                       limit: 255,                               null: false
    t.string   "slug",                       limit: 255
    t.decimal  "latitude",                                    precision: 10, scale: 6, null: false
    t.decimal  "longitude",                                   precision: 10, scale: 6, null: false
    t.string   "banner_image_file_name",     limit: 255,                               null: false
    t.string   "listing_image_file_name",    limit: 255,                               null: false
    t.integer  "position",                   limit: 4
    t.integer  "featured_home_community_id", limit: 4
    t.text     "description",                limit: 16777215
    t.text     "detail_description",         limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "home_neighborhoods", ["name"], name: "index_home_neighborhoods_on_name", unique: true, using: :btree
  add_index "home_neighborhoods", ["slug"], name: "index_home_neighborhoods_on_slug", using: :btree

  create_table "home_page_slides", force: :cascade do |t|
    t.integer  "home_page_id",       limit: 4,   null: false
    t.string   "image_file_name",    limit: 255, null: false
    t.string   "image_content_type", limit: 255, null: false
    t.integer  "position",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link_url",           limit: 255
  end

  create_table "home_pages", force: :cascade do |t|
    t.text     "body",                             limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meta_title",                       limit: 255
    t.string   "meta_description",                 limit: 255
    t.string   "meta_keywords",                    limit: 255
    t.string   "mobile_title",                     limit: 255
    t.string   "mobile_banner_image_file_name",    limit: 255
    t.string   "mobile_banner_image_content_type", limit: 255
    t.text     "mobile_body",                      limit: 65535
  end

  create_table "homes", force: :cascade do |t|
    t.string   "name",              limit: 255,                                         null: false
    t.integer  "bedrooms",          limit: 4,                                           null: false
    t.decimal  "bathrooms",                     precision: 3, scale: 1,                 null: false
    t.integer  "home_community_id", limit: 4,                                           null: false
    t.integer  "position",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "featured",                                              default: false, null: false
    t.integer  "square_feet",       limit: 4
  end

  create_table "images", force: :cascade do |t|
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.string   "caption",            limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "landing_page_popular_orderings", force: :cascade do |t|
    t.integer "landing_page_id", limit: 4
    t.integer "property_id",     limit: 4
    t.integer "position",        limit: 4
    t.string  "property_type",   limit: 255
  end

  create_table "landing_pages", force: :cascade do |t|
    t.string   "title",                          limit: 255,                   null: false
    t.string   "meta_title",                     limit: 255
    t.string   "meta_description",               limit: 255
    t.string   "meta_keywords",                  limit: 255
    t.string   "slug",                           limit: 255
    t.integer  "state_id",                       limit: 4,                     null: false
    t.text     "masthead_body",                  limit: 65535
    t.string   "masthead_image_file_name",       limit: 255
    t.string   "masthead_image_content_type",    limit: 255
    t.string   "secondary_title",                limit: 255
    t.text     "secondary_body",                 limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "promo_id",                       limit: 4
    t.boolean  "custom_sort_popular_properties",               default: false, null: false
    t.boolean  "published",                                    default: false, null: false
    t.boolean  "hide_from_list",                               default: false, null: false
    t.boolean  "randomize_property_listings"
    t.integer  "local_info_feed_id",             limit: 4
    t.boolean  "show_apartments_by_area",                      default: true
    t.string   "masthead_image_url",             limit: 255
  end

  add_index "landing_pages", ["slug"], name: "index_landing_pages_on_slug", using: :btree

  create_table "landing_pages_popular_properties", id: false, force: :cascade do |t|
    t.integer "landing_page_id", limit: 4
    t.integer "property_id",     limit: 4
  end

  add_index "landing_pages_popular_properties", ["landing_page_id", "property_id"], name: "index_landing_page_and_popular_properties", using: :btree

  create_table "landing_pages_projects", id: false, force: :cascade do |t|
    t.integer "landing_page_id", limit: 4
    t.integer "project_id",      limit: 4
  end

  add_index "landing_pages_projects", ["landing_page_id", "project_id"], name: "index_landing_pages_projects_on_landing_page_id_and_project_id", using: :btree

  create_table "lasso_accounts", force: :cascade do |t|
    t.integer  "property_id",  limit: 4,   null: false
    t.string   "uid",          limit: 255, null: false
    t.string   "client_id",    limit: 255, null: false
    t.string   "project_id",   limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "analytics_id", limit: 255
  end

  add_index "lasso_accounts", ["property_id"], name: "index_lasso_accounts_on_property_id", using: :btree

  create_table "leaders", force: :cascade do |t|
    t.string   "name",               limit: 255,      null: false
    t.string   "title",              limit: 255,      null: false
    t.string   "company",            limit: 255,      null: false
    t.text     "bio",                limit: 16777215, null: false
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",               limit: 255
  end

  add_index "leaders", ["slug"], name: "index_leaders_on_slug", using: :btree

  create_table "leadership_groups", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "position",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leaderships", force: :cascade do |t|
    t.integer  "leader_id",           limit: 4, null: false
    t.integer  "leadership_group_id", limit: 4, null: false
    t.integer  "position",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "leaderships", ["leader_id", "leadership_group_id"], name: "index_leaderships_on_leader_id_and_leadership_group_id", unique: true, using: :btree
  add_index "leaderships", ["leader_id"], name: "index_leaderships_on_leader_id", using: :btree
  add_index "leaderships", ["leadership_group_id"], name: "index_leaderships_on_leadership_group_id", using: :btree

  create_table "masthead_slides", force: :cascade do |t|
    t.text     "body",                  limit: 65535,             null: false
    t.integer  "slide_type",            limit: 4,     default: 0, null: false
    t.string   "image_file_name",       limit: 255
    t.string   "image_content_type",    limit: 255
    t.string   "image_link",            limit: 255
    t.text     "sidebar_text",          limit: 65535
    t.integer  "masthead_slideshow_id", limit: 4
    t.integer  "position",              limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mini_slideshow_id",     limit: 4
    t.text     "quote",                 limit: 65535
    t.string   "quote_attribution",     limit: 255
    t.string   "quote_job_title",       limit: 255
    t.string   "quote_company",         limit: 255
  end

  add_index "masthead_slides", ["masthead_slideshow_id"], name: "index_masthead_slides_on_masthead_slideshow_id", using: :btree
  add_index "masthead_slides", ["mini_slideshow_id"], name: "index_masthead_slides_on_mini_slideshow_id", using: :btree

  create_table "masthead_slideshows", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "page_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "masthead_slideshows", ["page_id"], name: "index_masthead_slideshows_on_page_id", using: :btree

  create_table "mediaplex_tags", force: :cascade do |t|
    t.string   "page_name",      limit: 255
    t.string   "roi_name",       limit: 255
    t.integer  "trackable_id",   limit: 4
    t.string   "trackable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mediaplex_tags", ["trackable_type", "trackable_id"], name: "index_mediaplex_tags_on_trackable_type_and_trackable_id", using: :btree

  create_table "metros", force: :cascade do |t|
    t.string   "name",                    limit: 255,                            null: false
    t.string   "slug",                    limit: 255
    t.decimal  "latitude",                              precision: 10, scale: 6, null: false
    t.decimal  "longitude",                             precision: 10, scale: 6, null: false
    t.integer  "position",                limit: 4
    t.string   "banner_image_file_name",  limit: 255
    t.string   "listing_image_file_name", limit: 255,                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "detail_description",      limit: 65535
  end

  add_index "metros", ["name"], name: "index_metros_on_name", unique: true, using: :btree
  add_index "metros", ["slug"], name: "index_metros_on_slug", using: :btree

  create_table "mini_slides", force: :cascade do |t|
    t.string   "image_file_name",    limit: 255, null: false
    t.string   "image_content_type", limit: 255, null: false
    t.integer  "position",           limit: 4
    t.integer  "mini_slideshow_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mini_slides", ["mini_slideshow_id"], name: "index_mini_slides_on_mini_slideshow_id", using: :btree

  create_table "mini_slideshows", force: :cascade do |t|
    t.string   "title",      limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subtitle",   limit: 255
    t.string   "link_url",   limit: 255
  end

  create_table "neighborhood_memberships", force: :cascade do |t|
    t.integer  "neighborhood_id",        limit: 4,             null: false
    t.integer  "apartment_community_id", limit: 4,             null: false
    t.integer  "position",               limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tier",                   limit: 4, default: 2, null: false
  end

  add_index "neighborhood_memberships", ["neighborhood_id"], name: "index_neighborhood_memberships_on_neighborhood_id", using: :btree
  add_index "neighborhood_memberships", ["tier"], name: "index_neighborhood_memberships_on_tier", using: :btree

  create_table "neighborhoods", force: :cascade do |t|
    t.string   "name",                            limit: 255,                            null: false
    t.string   "slug",                            limit: 255
    t.decimal  "latitude",                                      precision: 10, scale: 6, null: false
    t.decimal  "longitude",                                     precision: 10, scale: 6, null: false
    t.string   "banner_image_file_name",          limit: 255
    t.string   "listing_image_file_name",         limit: 255
    t.integer  "area_id",                         limit: 4,                              null: false
    t.integer  "position",                        limit: 4
    t.integer  "state_id",                        limit: 4,                              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "featured_apartment_community_id", limit: 4
    t.text     "description",                     limit: 65535
    t.text     "detail_description",              limit: 65535
  end

  add_index "neighborhoods", ["area_id"], name: "index_neighborhoods_on_area_id", using: :btree
  add_index "neighborhoods", ["name"], name: "index_neighborhoods_on_name", unique: true, using: :btree
  add_index "neighborhoods", ["slug"], name: "index_neighborhoods_on_slug", using: :btree

  create_table "news_posts", force: :cascade do |t|
    t.string   "title",                        limit: 255,                   null: false
    t.text     "body",                         limit: 65535
    t.boolean  "published",                                  default: false, null: false
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meta_title",                   limit: 255
    t.string   "meta_description",             limit: 255
    t.string   "meta_keywords",                limit: 255
    t.string   "image_file_name",              limit: 255
    t.string   "image_content_type",           limit: 255
    t.boolean  "featured",                                   default: false
    t.string   "home_page_image_file_name",    limit: 255
    t.string   "home_page_image_content_type", limit: 255
    t.boolean  "show_as_featured_news",                      default: false, null: false
  end

  create_table "news_posts_sections", id: false, force: :cascade do |t|
    t.integer "news_post_id", limit: 4
    t.integer "section_id",   limit: 4
  end

  add_index "news_posts_sections", ["news_post_id", "section_id"], name: "index_news_posts_sections_on_news_post_id_and_section_id", using: :btree
  add_index "news_posts_sections", ["section_id", "news_post_id"], name: "index_news_posts_sections_on_section_id_and_news_post_id", using: :btree

  create_table "office_hours", force: :cascade do |t|
    t.integer  "property_id",      limit: 4,                   null: false
    t.integer  "day",              limit: 4,                   null: false
    t.string   "opens_at",         limit: 255
    t.string   "opens_at_period",  limit: 255, default: "AM"
    t.string   "closes_at",        limit: 255
    t.string   "closes_at_period", limit: 255, default: "PM"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "closed",                       default: false, null: false
    t.string   "property_type",    limit: 255
  end

  add_index "office_hours", ["property_id", "day"], name: "index_office_hours_on_property_id_and_day", unique: true, using: :btree
  add_index "office_hours", ["property_id"], name: "index_office_hours_on_property_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "title",                          limit: 255,                   null: false
    t.string   "slug",                           limit: 255
    t.text     "body",                           limit: 65535
    t.integer  "parent_id",                      limit: 4
    t.integer  "lft",                            limit: 4
    t.integer  "rgt",                            limit: 4
    t.integer  "section_id",                     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "path",                           limit: 255
    t.string   "meta_title",                     limit: 255
    t.string   "meta_description",               limit: 255
    t.string   "meta_keywords",                  limit: 255
    t.string   "left_montage_image_file_name",   limit: 255
    t.string   "middle_montage_image_file_name", limit: 255
    t.string   "right_montage_image_file_name",  limit: 255
    t.boolean  "published",                                    default: false, null: false
    t.text     "mobile_body",                    limit: 65535
    t.text     "mobile_body_extra",              limit: 65535
    t.boolean  "show_sidebar",                                 default: true
    t.boolean  "show_in_sidebar_nav",                          default: true
    t.integer  "snippet_id",                     limit: 4
  end

  add_index "pages", ["path"], name: "index_pages_on_path", using: :btree
  add_index "pages", ["section_id"], name: "index_pages_on_section_id", using: :btree
  add_index "pages", ["slug"], name: "index_pages_on_slug", using: :btree

  create_table "photo_groups", force: :cascade do |t|
    t.string   "title",      limit: 255, null: false
    t.integer  "position",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photo_groups_photos", id: false, force: :cascade do |t|
    t.integer "photo_group_id", limit: 4
    t.integer "photo_id",       limit: 4
  end

  create_table "photo_sets", force: :cascade do |t|
    t.string   "title",             limit: 255,                 null: false
    t.string   "flickr_set_number", limit: 255,                 null: false
    t.integer  "property_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "needs_sync",                    default: false, null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string   "image_file_name",    limit: 255, default: ""
    t.string   "title",              limit: 255, default: "",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_content_type", limit: 255
    t.integer  "position",           limit: 4
    t.boolean  "show_to_mobile",                 default: false, null: false
    t.integer  "photo_group_id",     limit: 4
    t.integer  "property_id",        limit: 4,                   null: false
    t.string   "property_type",      limit: 255
  end

  create_table "press_releases", force: :cascade do |t|
    t.string   "title",                        limit: 255,                      null: false
    t.text     "body",                         limit: 16777215
    t.boolean  "published",                                     default: false, null: false
    t.datetime "published_at"
    t.string   "meta_title",                   limit: 255
    t.string   "meta_description",             limit: 255
    t.string   "meta_keywords",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "featured",                                      default: false
    t.boolean  "show_as_featured_news",                         default: false, null: false
    t.string   "home_page_image_file_name",    limit: 255
    t.string   "home_page_image_content_type", limit: 255
  end

  create_table "press_releases_sections", id: false, force: :cascade do |t|
    t.integer "press_release_id", limit: 4
    t.integer "section_id",       limit: 4
  end

  add_index "press_releases_sections", ["press_release_id", "section_id"], name: "index_press_releases_sections_on_press_release_id_and_section_id", using: :btree
  add_index "press_releases_sections", ["section_id", "press_release_id"], name: "index_press_releases_sections_on_section_id_and_press_release_id", using: :btree

  create_table "project_categories", force: :cascade do |t|
    t.string   "title",      limit: 255, null: false
    t.string   "slug",       limit: 255
    t.integer  "position",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_categories", ["slug"], name: "index_project_categories_on_slug", using: :btree

  create_table "project_categories_projects", id: false, force: :cascade do |t|
    t.integer "project_category_id", limit: 4
    t.integer "project_id",          limit: 4
  end

  create_table "project_data_points", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "data",       limit: 255, null: false
    t.integer  "project_id", limit: 4,   null: false
    t.integer  "position",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_updates", force: :cascade do |t|
    t.text     "body",               limit: 65535,                 null: false
    t.integer  "project_id",         limit: 4,                     null: false
    t.boolean  "published",                        default: false, null: false
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.string   "image_title",        limit: 255
    t.string   "image_description",  limit: 255
  end

  create_table "projects", force: :cascade do |t|
    t.string  "title",                      limit: 255,                                            null: false
    t.string  "slug",                       limit: 255
    t.string  "short_title",                limit: 255
    t.string  "short_description",          limit: 255
    t.string  "page_header",                limit: 255
    t.string  "section",                    limit: 255
    t.string  "section_id",                 limit: 255
    t.string  "street_address",             limit: 255
    t.integer "city_id",                    limit: 4
    t.integer "county_id",                  limit: 4
    t.string  "zip_code",                   limit: 255
    t.decimal "latitude",                                 precision: 10, scale: 6
    t.decimal "longitude",                                precision: 10, scale: 6
    t.string  "website_url",                limit: 255
    t.string  "website_url_text",           limit: 255
    t.string  "video_url",                  limit: 255
    t.integer "brochure_type",              limit: 4
    t.string  "brochure_url",               limit: 255
    t.string  "brochure_file_name",         limit: 255
    t.string  "brochure_content_type",      limit: 255
    t.string  "brochure_link_text",         limit: 255
    t.string  "listing_image_file_name",    limit: 255
    t.string  "listing_image_content_type", limit: 255
    t.string  "listing_title",              limit: 255
    t.text    "listing_text",               limit: 65535
    t.text    "overview_text",              limit: 65535
    t.string  "meta_title",                 limit: 255
    t.string  "meta_description",           limit: 255
    t.string  "meta_keywords",              limit: 255
    t.date    "completion_date",                                                                   null: false
    t.boolean "has_completion_date",                                               default: false, null: false
    t.boolean "published",                                                                         null: false
    t.boolean "featured_mobile",                                                   default: false, null: false
    t.integer "position",                   limit: 4
  end

  create_table "promos", force: :cascade do |t|
    t.string   "title",               limit: 255,                 null: false
    t.string   "subtitle",            limit: 255
    t.string   "link_url",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_expiration_date",             default: false
    t.datetime "expiration_date"
  end

  create_table "properties", force: :cascade do |t|
    t.string   "title",                                limit: 255,                                            null: false
    t.string   "subtitle",                             limit: 255
    t.integer  "city_id",                              limit: 4,                                              null: false
    t.boolean  "elite",                                                                       default: false, null: false
    t.boolean  "smart_share",                                                                 default: false, null: false
    t.boolean  "smart_rent",                                                                  default: false, null: false
    t.boolean  "green",                                                                       default: false, null: false
    t.boolean  "non_smoking",                                                                 default: false, null: false
    t.string   "website_url",                          limit: 255
    t.string   "video_url",                            limit: 255
    t.string   "facebook_url",                         limit: 255
    t.string   "promo_image",                          limit: 255
    t.string   "promo_url",                            limit: 255
    t.decimal  "latitude",                                           precision: 10, scale: 6
    t.decimal  "longitude",                                          precision: 10, scale: 6
    t.string   "street_address",                       limit: 255
    t.text     "overview_text",                        limit: 65535
    t.text     "promotions_text",                      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "local_info_feed_id",                   limit: 4
    t.string   "external_cms_id",                      limit: 255
    t.string   "availability_url",                     limit: 255
    t.string   "type",                                 limit: 255
    t.integer  "section_id",                           limit: 4
    t.integer  "county_id",                            limit: 4
    t.string   "listing_image_file_name",              limit: 255
    t.string   "listing_image_content_type",           limit: 255
    t.string   "listing_title",                        limit: 255
    t.text     "listing_text",                         limit: 65535
    t.integer  "features",                             limit: 4
    t.string   "overview_title",                       limit: 255
    t.string   "overview_bullet_1",                    limit: 255
    t.string   "overview_bullet_2",                    limit: 255
    t.string   "overview_bullet_3",                    limit: 255
    t.boolean  "published",                                                                   default: false, null: false
    t.string   "short_title",                          limit: 255
    t.string   "phone_number",                         limit: 255
    t.integer  "brochure_type",                        limit: 4,                              default: 0,     null: false
    t.string   "brochure_link_text",                   limit: 255
    t.string   "brochure_file_name",                   limit: 255
    t.string   "brochure_content_type",                limit: 255
    t.string   "brochure_url",                         limit: 255
    t.string   "slug",                                 limit: 255
    t.string   "meta_title",                           limit: 255
    t.string   "meta_description",                     limit: 255
    t.string   "meta_keywords",                        limit: 255
    t.boolean  "show_lead_2_lease",                                                           default: false, null: false
    t.string   "lead_2_lease_email",                   limit: 255
    t.date     "completion_date"
    t.string   "media_meta_title",                     limit: 255
    t.string   "media_meta_description",               limit: 255
    t.string   "media_meta_keywords",                  limit: 255
    t.string   "floor_plans_meta_title",               limit: 255
    t.string   "floor_plans_meta_description",         limit: 255
    t.string   "floor_plans_meta_keywords",            limit: 255
    t.string   "promotions_meta_title",                limit: 255
    t.string   "promotions_meta_description",          limit: 255
    t.string   "promotions_meta_keywords",             limit: 255
    t.integer  "position",                             limit: 4
    t.integer  "promo_id",                             limit: 4
    t.integer  "ufollowup_id",                         limit: 4
    t.boolean  "has_completion_date",                                                         default: true,  null: false
    t.string   "listing_promo_file_name",              limit: 255
    t.string   "listing_promo_content_type",           limit: 255
    t.integer  "listing_promo_file_size",              limit: 4
    t.string   "resident_link_text",                   limit: 255
    t.string   "resident_link_url",                    limit: 255
    t.boolean  "featured",                                                                    default: false, null: false
    t.integer  "featured_position",                    limit: 4
    t.string   "zip_code",                             limit: 255
    t.string   "lead_2_lease_id",                      limit: 255
    t.string   "mobile_phone_number",                  limit: 255
    t.integer  "twitter_account_id",                   limit: 4
    t.string   "send_to_friend_mediamind_id",          limit: 255
    t.string   "send_to_phone_mediamind_id",           limit: 255
    t.string   "contact_mediamind_id",                 limit: 255
    t.boolean  "featured_mobile",                                                             default: false
    t.boolean  "under_construction",                                                          default: false
    t.string   "external_cms_type",                    limit: 255
    t.string   "schedule_tour_url",                    limit: 255
    t.string   "seo_link_text",                        limit: 255
    t.string   "seo_link_url",                         limit: 255
    t.boolean  "show_rtrk_code",                                                              default: false, null: false
    t.text     "office_hours",                         limit: 65535
    t.string   "pinterest_url",                        limit: 255
    t.string   "website_url_text",                     limit: 255
    t.text     "neighborhood_description",             limit: 65535
    t.string   "neighborhood_listing_image_file_name", limit: 255
    t.boolean  "included_in_export",                                                          default: true,  null: false
    t.integer  "secondary_lead_source_id",             limit: 4
    t.string   "hero_image_file_name",                 limit: 255
    t.string   "hero_image_content_type",              limit: 255
    t.integer  "hero_image_file_size",                 limit: 4
    t.string   "hyly_id",                              limit: 255
    t.integer  "core_id",                              limit: 4
    t.string   "page_header",                          limit: 255
    t.string   "short_description",                    limit: 255
    t.integer  "unit_count",                           limit: 4
    t.string   "external_management_id",               limit: 255
    t.boolean  "found_in_latest_feed",                                                        default: true,  null: false
  end

  add_index "properties", ["core_id"], name: "index_properties_on_core_id", using: :btree
  add_index "properties", ["external_cms_id", "external_cms_type"], name: "index_properties_on_external_cms_id_and_external_cms_type", using: :btree
  add_index "properties", ["external_cms_id"], name: "index_properties_on_external_cms_id", using: :btree
  add_index "properties", ["included_in_export"], name: "index_properties_on_included_in_export", using: :btree
  add_index "properties", ["slug"], name: "index_properties_on_slug", using: :btree

  create_table "property_amenities", force: :cascade do |t|
    t.integer  "property_id",   limit: 4,                     null: false
    t.string   "primary_type",  limit: 255, default: "Other", null: false
    t.string   "sub_type",      limit: 255
    t.string   "description",   limit: 255
    t.integer  "position",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "property_type", limit: 255
  end

  add_index "property_amenities", ["property_id"], name: "index_property_amenities_on_property_id", using: :btree

  create_table "property_contact_pages", force: :cascade do |t|
    t.integer  "property_id",              limit: 4,        null: false
    t.text     "content",                  limit: 16777215
    t.string   "meta_title",               limit: 255
    t.string   "meta_description",         limit: 255
    t.string   "meta_keywords",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "schedule_appointment_url", limit: 255
    t.string   "local_phone_number",       limit: 255
    t.string   "property_type",            limit: 255
    t.text     "contact_form_note",        limit: 65535
    t.text     "thank_you_text",           limit: 65535
  end

  add_index "property_contact_pages", ["property_id"], name: "index_property_contact_pages_on_property_id", using: :btree

  create_table "property_feature_attributions", force: :cascade do |t|
    t.integer  "property_id",         limit: 4,   null: false
    t.string   "property_type",       limit: 255, null: false
    t.integer  "property_feature_id", limit: 4,   null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "property_feature_attributions", ["property_feature_id"], name: "index_property_feature_attributions_on_property_feature_id", using: :btree
  add_index "property_feature_attributions", ["property_id", "property_type", "property_feature_id"], name: "index_properties_and_features", unique: true, using: :btree
  add_index "property_feature_attributions", ["property_id", "property_type"], name: "index_property_id_and_type_on_feature_attribution", using: :btree

  create_table "property_features", force: :cascade do |t|
    t.string   "icon_file_name",      limit: 255
    t.string   "icon_content_type",   limit: 255
    t.string   "name",                limit: 255
    t.text     "description",         limit: 65535
    t.integer  "position",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_on_search_page",               default: false, null: false
  end

  create_table "property_features_pages", force: :cascade do |t|
    t.integer  "property_id",      limit: 4,        null: false
    t.text     "text_1",           limit: 16777215
    t.string   "title_1",          limit: 255
    t.string   "title_2",          limit: 255
    t.text     "text_2",           limit: 16777215
    t.string   "title_3",          limit: 255
    t.text     "text_3",           limit: 16777215
    t.string   "meta_title",       limit: 255
    t.string   "meta_description", limit: 255
    t.string   "meta_keywords",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "property_type",    limit: 255
  end

  add_index "property_features_pages", ["property_id"], name: "index_property_features_pages_on_property_id", using: :btree

  create_table "property_feed_imports", force: :cascade do |t|
    t.string   "type",              limit: 255,   null: false
    t.string   "state",             limit: 255,   null: false
    t.string   "file_file_name",    limit: 255
    t.string   "file_file_size",    limit: 255
    t.string   "file_content_type", limit: 255
    t.text     "error",             limit: 65535
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "property_neighborhood_pages", force: :cascade do |t|
    t.integer  "property_id",      limit: 4,        null: false
    t.text     "content",          limit: 16777215
    t.string   "meta_title",       limit: 255
    t.string   "meta_description", limit: 255
    t.string   "meta_keywords",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "property_type",    limit: 255
  end

  add_index "property_neighborhood_pages", ["property_id"], name: "index_property_neighborhood_pages_on_property_id", using: :btree

  create_table "property_retail_pages", force: :cascade do |t|
    t.integer  "property_id",      limit: 4,     null: false
    t.text     "content",          limit: 65535
    t.string   "meta_title",       limit: 255
    t.string   "meta_description", limit: 255
    t.string   "meta_keywords",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "property_type",    limit: 255
  end

  create_table "property_retail_slides", force: :cascade do |t|
    t.string   "name",                    limit: 255, null: false
    t.string   "image_file_name",         limit: 255, null: false
    t.string   "image_content_type",      limit: 255, null: false
    t.string   "video_url",               limit: 255
    t.string   "link_url",                limit: 255
    t.integer  "position",                limit: 4
    t.integer  "property_retail_page_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "property_slides", force: :cascade do |t|
    t.string   "caption",               limit: 255
    t.string   "image_file_name",       limit: 255, null: false
    t.string   "image_content_type",    limit: 255, null: false
    t.integer  "position",              limit: 4
    t.integer  "property_slideshow_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "video_url",             limit: 255
    t.string   "link_url",              limit: 255
  end

  add_index "property_slides", ["property_slideshow_id"], name: "index_property_slides_on_property_slideshow_id", using: :btree

  create_table "property_slideshows", force: :cascade do |t|
    t.string   "name",          limit: 255, null: false
    t.integer  "property_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "property_type", limit: 255
  end

  add_index "property_slideshows", ["property_id"], name: "index_property_slideshows_on_property_id", using: :btree

  create_table "property_tours_pages", force: :cascade do |t|
    t.integer  "property_id",      limit: 4,        null: false
    t.string   "title",            limit: 255
    t.text     "content",          limit: 16777215
    t.string   "meta_title",       limit: 255
    t.string   "meta_description", limit: 255
    t.string   "meta_keywords",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "property_type",    limit: 255
  end

  add_index "property_tours_pages", ["property_id"], name: "index_property_tours_pages_on_property_id", using: :btree

  create_table "publications", force: :cascade do |t|
    t.string   "name",               limit: 255,                      null: false
    t.text     "description",        limit: 16777215
    t.integer  "position",           limit: 4
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.boolean  "published",                           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "publications", ["published", "position"], name: "index_publications_on_published_and_position", using: :btree

  create_table "rank_categories", force: :cascade do |t|
    t.string   "name",           limit: 255, null: false
    t.integer  "position",       limit: 4
    t.integer  "publication_id", limit: 4,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rank_categories", ["publication_id", "position"], name: "index_rank_categories_on_publication_id_and_position", using: :btree

  create_table "ranks", force: :cascade do |t|
    t.integer  "rank_number",      limit: 4,   null: false
    t.integer  "year",             limit: 4,   null: false
    t.string   "description",      limit: 255
    t.integer  "rank_category_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ranks", ["rank_category_id", "year"], name: "index_ranks_on_rank_category_id_and_year", using: :btree

  create_table "recurring_emails", force: :cascade do |t|
    t.string   "email_address", limit: 255,                         null: false
    t.string   "token",         limit: 255,                         null: false
    t.text     "property_ids",  limit: 16777215
    t.boolean  "recurring",                      default: false
    t.datetime "last_sent_at"
    t.string   "state",         limit: 255,      default: "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recurring_emails", ["email_address"], name: "index_recurring_emails_on_email_address", using: :btree
  add_index "recurring_emails", ["state"], name: "index_recurring_emails_on_state", using: :btree
  add_index "recurring_emails", ["token"], name: "index_recurring_emails_on_token", using: :btree

  create_table "related_areas", force: :cascade do |t|
    t.integer  "area_id",        limit: 4, null: false
    t.integer  "nearby_area_id", limit: 4, null: false
    t.integer  "position",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "related_areas", ["area_id", "nearby_area_id"], name: "index_related_areas_on_area_id_and_nearby_area_id", unique: true, using: :btree
  add_index "related_areas", ["area_id"], name: "index_related_areas_on_area_id", using: :btree

  create_table "related_neighborhoods", force: :cascade do |t|
    t.integer  "neighborhood_id",        limit: 4, null: false
    t.integer  "nearby_neighborhood_id", limit: 4, null: false
    t.integer  "position",               limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "related_neighborhoods", ["neighborhood_id"], name: "index_related_neighborhoods_on_neighborhood_id", using: :btree

  create_table "sections", force: :cascade do |t|
    t.string   "title",                          limit: 255,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug",                           limit: 255
    t.boolean  "service",                                    default: false, null: false
    t.string   "left_montage_image_file_name",   limit: 255
    t.string   "middle_montage_image_file_name", limit: 255
    t.string   "right_montage_image_file_name",  limit: 255
    t.boolean  "about",                                      default: false, null: false
  end

  add_index "sections", ["about"], name: "index_sections_on_about", using: :btree
  add_index "sections", ["slug"], name: "index_sections_on_slug", using: :btree

  create_table "seo_metadata", force: :cascade do |t|
    t.integer  "resource_id",      limit: 4,   null: false
    t.string   "resource_type",    limit: 255, null: false
    t.string   "meta_title",       limit: 255
    t.string   "meta_description", limit: 255
    t.string   "meta_keywords",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "snippets", force: :cascade do |t|
    t.string   "name",       limit: 255,      null: false
    t.text     "body",       limit: 16777215, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: :cascade do |t|
    t.string   "code",       limit: 255, null: false
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",   limit: 4
  end

  add_index "states", ["position"], name: "index_states_on_position", using: :btree

  create_table "testimonials", force: :cascade do |t|
    t.string   "name",       limit: 255,   default: ""
    t.string   "title",      limit: 255,   default: ""
    t.text     "quote",      limit: 65535,              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "section_id", limit: 4
  end

  create_table "tweets", force: :cascade do |t|
    t.string   "tweet_id",           limit: 255,      null: false
    t.text     "text",               limit: 16777215, null: false
    t.datetime "posted_at",                           null: false
    t.integer  "twitter_account_id", limit: 4,        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tweets", ["tweet_id"], name: "index_tweets_on_tweet_id", using: :btree
  add_index "tweets", ["twitter_account_id"], name: "index_tweets_on_twitter_account_id", using: :btree

  create_table "twitter_accounts", force: :cascade do |t|
    t.string   "username",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "next_update_at",             null: false
  end

  add_index "twitter_accounts", ["username"], name: "index_twitter_accounts_on_username", using: :btree

  create_table "under_construction_leads", force: :cascade do |t|
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "address",                limit: 255
    t.string   "address_2",              limit: 255
    t.string   "city",                   limit: 255
    t.string   "state",                  limit: 255
    t.string   "zip_code",               limit: 255
    t.string   "phone_number",           limit: 255
    t.string   "email",                  limit: 255
    t.integer  "apartment_community_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comments",               limit: 16777215
  end

  add_index "under_construction_leads", ["apartment_community_id"], name: "index_under_construction_leads_on_apartment_community_id", using: :btree

  create_table "videos", force: :cascade do |t|
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.string   "url",                limit: 255, null: false
    t.integer  "property_id",        limit: 4
    t.integer  "position",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "property_type",      limit: 255
  end

  create_table "zip_codes", force: :cascade do |t|
    t.string  "zip",       limit: 255,                          null: false
    t.decimal "latitude",              precision: 10, scale: 6, null: false
    t.decimal "longitude",             precision: 10, scale: 6, null: false
  end

  add_index "zip_codes", ["zip"], name: "index_zip_codes_on_zip", unique: true, using: :btree

end
