class AddScheduleTourUrlToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :schedule_tour_url, :string
  end

  def self.down
    remove_column :properties, :schedule_tour_url
  end
end
