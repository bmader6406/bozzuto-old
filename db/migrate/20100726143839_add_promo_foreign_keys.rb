class AddPromoForeignKeys < ActiveRecord::Migration
  def self.up
    add_column :properties, :promo_id, :integer
    add_column :landing_pages, :promo_id, :integer
  end

  def self.down
    remove_column :properties, :promo_id
    remove_column :landing_pages, :promo_id
  end
end
