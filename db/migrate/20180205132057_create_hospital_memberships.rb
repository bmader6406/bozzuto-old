class CreateHospitalMemberships < ActiveRecord::Migration
  def self.up
    create_table :hospital_memberships do |t|
      t.integer :hospital_id
      t.integer :apartment_community_id
      t.integer :position

      t.timestamps null: false
    end

    add_index :hospital_memberships, :hospital_id
    add_index :hospital_memberships, :apartment_community_id
  end

  def self.down
    drop_table :hospital_memberships
  end
end
