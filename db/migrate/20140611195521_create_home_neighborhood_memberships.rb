class CreateHomeNeighborhoodMemberships < ActiveRecord::Migration
  def self.up
    create_table :home_neighborhood_memberships, :force => true do |t|
      t.integer  :home_neighborhood_id, :null => false
      t.integer  :home_community_id,    :null => false
      t.integer  :position

      t.timestamps
    end

    add_index :home_neighborhood_memberships, :home_neighborhood_id
    add_index :home_neighborhood_memberships, [:home_neighborhood_id, :home_community_id], :unique => true, :name => 'index_home_nbrhd_mmbrshps_on_nbrhd_id_and_comm_id'
  end

  def self.down
    drop_table :home_neighborhood_memberships
  end
end
