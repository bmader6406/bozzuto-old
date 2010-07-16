class AddLead2LeaseToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :show_lead_2_lease, :boolean, :null => false, :default => false
    add_column :properties, :lead_2_lease_email, :string
  end

  def self.down
    remove_column :properties, :show_lead_2_lease
    remove_column :properties, :lead_2_lease_email
  end
end
