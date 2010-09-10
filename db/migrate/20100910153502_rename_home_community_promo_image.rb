class RenameHomeCommunityPromoImage < ActiveRecord::Migration
  def self.up
    rename_column :properties, :promo_file_name, :listing_promo_file_name
    rename_column :properties, :promo_content_type, :listing_promo_content_type
    rename_column :properties, :promo_file_size, :listing_promo_file_size
  end

  def self.down
    rename_column :properties, :listing_promo_file_name, :promo_file_name
    rename_column :properties, :listing_promo_content_type, :promo_content_type
    rename_column :properties, :listing_promo_file_size, :promo_file_size
  end
end
