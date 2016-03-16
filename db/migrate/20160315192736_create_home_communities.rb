class CreateHomeCommunities < ActiveRecord::Migration
  def change
    create_table :home_communities do |t|
      t.string  :title, null: false
      t.string  :short_title
      t.string  :street_address
      t.string  :zip_code
      t.decimal :latitude,  precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.string  :website_url
      t.string  :website_url_text
      t.string  :video_url
      t.string  :availability_url
      t.string  :listing_title
      t.text    :listing_text
      t.string  :overview_title
      t.text    :overview_text
      t.string  :overview_bullet_1
      t.string  :overview_bullet_2
      t.string  :overview_bullet_3
      t.integer :brochure_type, null: false, default: 0
      t.string  :brochure_link_text
      t.string  :brochure_url
      t.text    :neighborhood_description

      t.boolean :published,      null: false, default: false
      t.boolean :show_rtrk_code, null: false, default: false

      # Meta
      t.string :meta_title
      t.string :meta_description
      t.string :meta_keywords
      t.string :media_meta_title
      t.string :media_meta_description
      t.string :media_meta_keywords
      t.string :floor_plans_meta_title
      t.string :floor_plans_meta_description
      t.string :floor_plans_meta_keywords

      # Library-backed fields
      t.string  :slug     # friendly_id
      t.integer :position # acts_as_list

      # Attachments
      t.string  :listing_image_file_name
      t.string  :listing_image_content_type
      t.string  :listing_promo_file_name
      t.string  :listing_promo_content_type
      t.integer :listing_promo_file_size
      t.string  :brochure_file_name
      t.string  :brochure_content_type
      t.string  :neighborhood_listing_image_file_name
      t.string  :neighborhood_listing_image_content_type

      # Contact-related
      t.string :phone_number
      t.string :mobile_phone_number

      # Social
      t.string :facebook_url

      # Codes
      t.integer :ufollowup_id
      t.integer :secondary_lead_source_id

      # Associations
      t.integer :city_id
      t.integer :county_id
      t.integer :local_info_feed_id
      t.integer :promo_id
      t.integer :twitter_account_id

      t.timestamps
    end

    add_index :home_communities, :slug
  end
end
