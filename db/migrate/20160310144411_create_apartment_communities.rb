class CreateApartmentCommunities < ActiveRecord::Migration
  def change
    create_table :apartment_communities do |t|
      t.string  :title, null: false
      t.string  :short_title
      t.string  :short_description
      t.string  :subtitle
      t.string  :street_address
      t.string  :zip_code
      t.decimal :latitude,  precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.string  :website_url
      t.string  :website_url_text
      t.string  :video_url
      t.string  :promo_image
      t.string  :promo_url
      t.text    :promotions_text
      t.text    :overview_text
      t.string  :availability_url
      t.string  :listing_title
      t.text    :listing_text
      t.string  :overview_title
      t.string  :overview_bullet_1
      t.string  :overview_bullet_2
      t.string  :overview_bullet_3
      t.integer :brochure_type, null: false, default: 0
      t.string  :brochure_link_text
      t.string  :brochure_url
      t.string  :resident_link_text
      t.string  :resident_link_url
      t.text    :office_hours
      t.string  :schedule_tour_url
      t.text    :neighborhood_description
      t.string  :page_header

      t.boolean :published,          null: false, default: false
      t.boolean :featured,           null: false, default: false
      t.boolean :elite,              null: false, default: false
      t.boolean :smart_share,        null: false, default: false
      t.boolean :smart_rent,         null: false, default: false
      t.boolean :green,              null: false, default: false
      t.boolean :non_smoking,        null: false, default: false
      t.boolean :show_lead_2_lease,  null: false, default: false
      t.boolean :featured_mobile,    null: false, default: false
      t.boolean :under_construction, null: false, default: false
      t.boolean :show_rtrk_code,     null: false, default: false

      # Meta
      t.string  :meta_title
      t.string  :meta_description
      t.string  :meta_keywords
      t.string  :media_meta_title
      t.string  :media_meta_description
      t.string  :media_meta_keywords
      t.string  :floor_plans_meta_title
      t.string  :floor_plans_meta_description
      t.string  :floor_plans_meta_keywords
      t.string  :promotions_meta_title
      t.string  :promotions_meta_description
      t.string  :promotions_meta_keywords
      t.string  :seo_link_url
      t.string  :seo_link_text

      # Library-backed fields
      t.string  :slug              # friendly_id
      t.integer :position          # acts_as_list
      t.integer :featured_position # acts_as_list

      # Attachments
      t.string :listing_image_file_name
      t.string :listing_image_content_type
      t.string :brochure_file_name
      t.string :brochure_content_type
      t.string :hero_image_file_name
      t.string :hero_image_content_type
      t.string :hero_image_file_size
      t.string :neighborhood_listing_image_file_name
      t.string :neighborhood_listing_image_content_type

      # Contact-related
      t.string  :phone_number
      t.string  :mobile_phone_number
      t.string  :lead_2_lease_email
      t.string  :lead_2_lease_id

      # Feed-related
      t.string  :external_cms_id
      t.string  :external_cms_type
      t.string  :external_management_id
      t.integer :core_id
      t.integer :unit_count
      t.boolean :included_in_export,   null: false, default: true
      t.boolean :found_in_latest_feed, null: false, default: true

      # Social
      t.string  :facebook_url
      t.string  :pinterest_url

      # Codes
      t.integer :ufollowup_id
      t.string  :send_to_friend_mediamind_id
      t.string  :send_to_phone_mediamind_id
      t.string  :contact_mediamind_id
      t.string  :hyly_id

      # Associations
      t.integer :city_id
      t.integer :county_id
      t.integer :local_info_feed_id
      t.integer :promo_id
      t.integer :twitter_account_id

      t.timestamps
    end

    add_index :apartment_communities, :slug
    add_index :apartment_communities, :core_id
    add_index :apartment_communities, [:external_cms_id, :external_cms_type], unique: true, name: 'index_apt_communities_on_external_cms_id_and_type'
  end
end
