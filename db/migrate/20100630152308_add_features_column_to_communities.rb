class AddFeaturesColumnToCommunities < ActiveRecord::Migration
  def self.up
    add_column :properties, :features, :int
  end

  def self.down
    remove_column :properties, :features
  end
end
