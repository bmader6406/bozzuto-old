class PopulateCoreIdsForProperties < ActiveRecord::Migration
  def self.up
    Bozzuto::ExternalFeed::CoreIdManager.assign_core_ids!
  end

  def self.down
    Bozzuto::ExternalFeed::CoreIdManager.clear_core_ids!
  end
end
