class AddFeaturedMobileFlagToProducts < ActiveRecord::Migration
  def self.up
    add_column :properties, :featured_mobile, :boolean, :default => false
  end

  def self.down
    remove_column :properties, :featured_mobile
  end
end
