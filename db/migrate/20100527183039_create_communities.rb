class CreateCommunities < ActiveRecord::Migration
  def self.up
    create_table :communities do |t|
      t.with_options :null => false do |n|
        n.string :title
        n.string :subtitle
        n.integer :city_id

        n.boolean :elite, :default => false
        n.boolean :smart_share, :default => false
        n.boolean :smart_rent, :default => false
        n.boolean :green, :default => false
        n.boolean :non_smoking, :default => false
      end

      t.string :video_url
      t.string :facebook_url
      t.string :twitter_handle

      t.string :promo_image_file_name
      t.string :promo_image_content_type
      t.integer :promo_image_file_size
      t.datetime :promo_image_updated_at
      t.string :promo_url
      
      t.float :latitude
      t.float :longitude
      t.string :street_address
       
      t.text :overview_text
      t.text :apartment_features
      t.text :community_amenties
      t.text :environmental_features
      t.text :contact_info

      t.timestamps
    end
  end

  def self.down
    drop_table :communities
  end
end
