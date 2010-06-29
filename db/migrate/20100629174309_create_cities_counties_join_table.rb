class CreateCitiesCountiesJoinTable < ActiveRecord::Migration
  def self.up
    remove_column :cities, :county_id

    create_table :cities_counties, :id => false do |t|
      t.integer :city_id
      t.integer :county_id
    end
  end

  def self.down
    add_column :cities, :county_id, :integer
    drop_table :cities_counties
  end
end
