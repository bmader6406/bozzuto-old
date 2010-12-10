class AddDnrCustomerCodeToCommunities < ActiveRecord::Migration
  def self.up
    add_column :properties, :dnr_customer_code, :string
  end

  def self.down
    remove_column :properties, :dnr_customer_code
  end
end
