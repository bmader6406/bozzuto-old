class AddPromoImageToHome < ActiveRecord::Migration
  def self.up
    add_column :properties, :promo_file_name, :string
    add_column :properties, :promo_content_type, :string
    add_column :properties, :promo_file_size, :integer
  end

  def self.down
    remove_column :properties, :promo_file_name
    remove_column :properties, :promo_content_type
    remove_column :properties, :promo_file_size
  end
end
