class AddExpirationDateToPromo < ActiveRecord::Migration
  def self.up
    add_column :promos, :has_expiration_date, :boolean, :default => false
    add_column :promos, :expiration_date, :timestamp, :default => nil
  end

  def self.down
    remove_column :promos, :has_expiration_date
    remove_column :promos, :expiration_date
  end
end
