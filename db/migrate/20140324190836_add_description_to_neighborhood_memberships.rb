class AddDescriptionToNeighborhoodMemberships < ActiveRecord::Migration
  def self.up
    add_column :neighborhood_memberships, :description, :text
  end

  def self.down
    remove_column :neighborhood_memberships, :description
  end
end
