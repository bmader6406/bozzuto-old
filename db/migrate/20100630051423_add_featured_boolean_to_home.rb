class AddFeaturedBooleanToHome < ActiveRecord::Migration
  def self.up
    add_column :homes, :featured, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :homes, :featured
  end
end
