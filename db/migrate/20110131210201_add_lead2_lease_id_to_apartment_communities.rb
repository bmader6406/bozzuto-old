class AddLead2LeaseIdToApartmentCommunities < ActiveRecord::Migration
  def self.up
    add_column :properties, :lead_2_lease_id, :string
  end

  def self.down
    remove_column :properties, :lead_2_lease_id, :string
  end
end
