class CreateZipCodes < ActiveRecord::Migration
  def self.up
    create_table :zip_codes do |t|
      t.string  :zip,       null: false
      t.decimal :latitude,  null: false, precision: 10, scale: 6
      t.decimal :longitude, null: false, precision: 10, scale: 6
    end

    add_index :zip_codes, :zip, unique: true

    execute %Q(
      LOAD DATA LOCAL INFILE '#{Rails.root.join('db', 'seeds', 'zipcode_data.csv')}'
      INTO TABLE zip_codes
      FIELDS TERMINATED BY ','
      LINES TERMINATED BY '\n'
      IGNORE 1 LINES
      (zip, latitude, longitude)
    )
  end

  def self.down
    drop_table :zip_codes
  end
end
