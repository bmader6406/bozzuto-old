class AddValueColumnToAdSources < ActiveRecord::Migration
  def self.up
    add_column :ad_sources, :value, :string, :null => false
  end

  def self.down
    remove_column :ad_sources, :value
  end
end
