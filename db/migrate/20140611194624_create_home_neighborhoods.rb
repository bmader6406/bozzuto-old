class CreateHomeNeighborhoods < ActiveRecord::Migration
  def self.up
    create_table :home_neighborhoods, :force => true do |t|
      t.string   :name,                      :null => false
      t.string   :cached_slug
      t.float    :latitude,                  :null => false
      t.float    :longitude,                 :null => false
      t.string   :banner_image_file_name,    :null => false
      t.string   :listing_image_file_name,   :null => false
      t.integer  :position
      t.integer  :featured_home_community_id
      t.integer  :home_communities_count,    :default => 0
      t.text     :description
      t.text     :detail_description

      t.timestamps
    end

    add_index :home_neighborhoods, :name, :unique => true
    add_index :home_neighborhoods, :cached_slug
  end

  def self.down
    drop_table :home_neighborhoods
  end
end
