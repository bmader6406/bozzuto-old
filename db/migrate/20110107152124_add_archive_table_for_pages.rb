class AddArchiveTableForPages < ActiveRecord::Migration
  def self.up
    ActsAsArchive.update Page
  end

  def self.down
    drop_table :archived_pages
  end
end
