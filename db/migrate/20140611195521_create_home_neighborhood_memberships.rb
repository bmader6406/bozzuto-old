class CreateHomeNeighborhoodMemberships < ActiveRecord::Migration
  def self.up
    create_table :home_neighborhood_memberships, :force => true do |t|
      t.integer  :home_neighborhood_id, :null => false
      t.integer  :home_community_id,    :null => false
      t.integer  :position

      t.timestamps
    end

    add_index :home_neighborhood_memberships, :home_neighborhood_id
    add_index :home_neighborhood_memberships, [:home_neighborhood_id, :home_community_id], :unique => true
  end

  def self.down
    drop_table :home_neighborhood_memberships
  end
end
