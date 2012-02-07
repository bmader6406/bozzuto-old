class CreateUnderConstructionLeads < ActiveRecord::Migration
  def self.up
    create_table :under_construction_leads do |t|
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :phone_number
      t.string :email
      t.integer :apartment_community_id

      t.timestamps
    end

    add_index :under_construction_leads, :apartment_community_id
  end

  def self.down
    drop_table :under_construction_leads
  end
end
