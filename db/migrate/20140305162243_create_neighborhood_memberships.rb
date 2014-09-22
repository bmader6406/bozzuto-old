class CreateNeighborhoodMemberships < ActiveRecord::Migration
  def self.up
    create_table :neighborhood_memberships do |t|
      t.integer :neighborhood_id,        :null => false
      t.integer :apartment_community_id, :null => false
      t.integer :position

      t.timestamps
    end

    add_index :neighborhood_memberships, :neighborhood_id
    add_index :neighborhood_memberships, [:neighborhood_id, :apartment_community_id], :unique => true, :name => 'index_neighborhood_id_and_apartment_community_id'
  end

  def self.down
    drop_table :neighborhood_memberships
  end
end
