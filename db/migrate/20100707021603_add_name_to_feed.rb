class AddNameToFeed < ActiveRecord::Migration
  def self.up
    add_column :feeds, :name, :string, :null => false

    Feed.all.each do |feed|
      if feed.name.blank?
        feed.name = feed.url
        feed.save
      end
    end
  end

  def self.down
    remove_column :feeds, :name
  end
end
