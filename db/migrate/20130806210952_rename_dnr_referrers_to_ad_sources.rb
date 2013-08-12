class RenameDnrReferrersToAdSources < ActiveRecord::Migration
  def self.up
    rename_table :dnr_referrers, :ad_sources
  end

  def self.down
    rename_table :ad_sources, :dnr_referrers
  end
end
