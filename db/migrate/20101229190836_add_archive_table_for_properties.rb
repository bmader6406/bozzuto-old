class AddArchiveTableForProperties < ActiveRecord::Migration
  def self.up
    ActsAsArchive.update Property
  end

  def self.down
    drop_table :archived_properties
  end
end
