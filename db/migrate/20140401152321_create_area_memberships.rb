class CreateAreaMemberships < ActiveRecord::Migration
  def self.up
    create_table :area_memberships do |t|
      t.integer  :area_id,                :null => false
      t.integer  :apartment_community_id, :null => false
      t.integer  :position

      t.timestamps
    end

    add_index :area_memberships, :area_id
  end

  def self.down
    drop_table :area_memberships
  end
end
