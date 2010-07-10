class AddSyncFlagToPhotoSet < ActiveRecord::Migration
  def self.up
    add_column :photo_sets, :needs_sync, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :photo_sets, :needs_sync
  end
end
