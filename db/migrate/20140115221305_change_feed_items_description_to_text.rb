class ChangeFeedItemsDescriptionToText < ActiveRecord::Migration
  def self.up
    change_column :feed_items, :description, :text, :null => false
  end

  def self.down
    change_column :feed_items, :description, :text, :null => false
  end
end
