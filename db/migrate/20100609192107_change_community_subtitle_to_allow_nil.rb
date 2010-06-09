class ChangeCommunitySubtitleToAllowNil < ActiveRecord::Migration
  def self.up
    change_column :communities, :subtitle, :string, :null => true
  end

  def self.down
    change_column :communities, :subtitle, :string, :null => false
  end
end
