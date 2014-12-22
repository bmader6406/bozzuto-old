class CreateZipCodes < ActiveRecord::Migration
  def self.up
    create_table :zip_codes do |t|
      t.string  :zip,       null: false
      t.decimal :latitude,  null: false, precision: 10, scale: 6
      t.decimal :longitude, null: false, precision: 10, scale: 6
    end

    add_index :zip_codes, :zip, unique: true
  end

  def self.down
    drop_table :zip_codes
  end
end
