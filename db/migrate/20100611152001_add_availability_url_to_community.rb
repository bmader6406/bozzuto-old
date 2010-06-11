class AddAvailabilityUrlToCommunity < ActiveRecord::Migration
  def self.up
    add_column :communities, :availability_url, :string
  end

  def self.down
    remove_column :communities, :availability_url
  end
end
