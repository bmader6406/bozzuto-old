class AddZipCodeToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :zip_code, :string
  end

  def self.down
    remove_column :properties, :zip_code
  end
end
