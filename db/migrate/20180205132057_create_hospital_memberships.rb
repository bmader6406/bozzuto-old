class CreateHospitalMemberships < ActiveRecord::Migration
  def change
    create_table :hospital_memberships do |t|
      t.integer :hospital_id
      t.integer :apartment_community_id
      t.integer :position

      t.timestamps null: false
    end
  end
end
