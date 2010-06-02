class CreateCommunities < ActiveRecord::Migration
  def self.up
    create_table :communities do |t|
      t.with_options :null => false do |n|
        n.string :title
        n.string :subtitle
        n.integer :city_id

        n.boolean :elite,       :default => false
        n.boolean :smart_share, :default => false
        n.boolean :smart_rent,  :default => false
        n.boolean :green,       :default => false
        n.boolean :non_smoking, :default => false
      end

      t.string :website_url

      t.string :video_url
      t.string :facebook_url
      t.string :twitter_handle

      t.string :promo_image
      t.string :promo_url
      
      t.float :latitude
      t.float :longitude
      t.string :street_address
       
      t.text :overview_text
      t.text :features_text
      t.text :neighborhood_text
      t.text :promotions_text
      t.text :contact_text

      t.timestamps
    end
  end

  def self.down
    drop_table :communities
  end
end
