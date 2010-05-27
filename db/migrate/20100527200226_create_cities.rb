class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.with_options :null => false do |n|
        n.string :name
        n.integer :state_id
      end
      t.timestamps
    end
  end

  def self.down
    drop_table :cities
  end
end
