class CreateApartmentContactConfigurations < ActiveRecord::Migration
  def self.up
    create_table :apartment_contact_configurations do |t|
      t.integer :apartment_community_id, :null => false

      t.text :upcoming_intro_text
      t.text :upcoming_thank_you_text

      t.timestamps
    end

    add_index :apartment_contact_configurations, :apartment_community_id
  end

  def self.down
    remove_index :apartment_contact_configurations, :apartment_community_id

    drop_table :apartment_contact_configurations
  end
end
