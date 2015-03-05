class CreateOfficeHours < ActiveRecord::Migration
  def self.up
    create_table :office_hours do |t|
      t.integer :property_id,      :null => false
      t.integer :day,              :null => false
      t.string  :opens_at,         :null => false
      t.string  :opens_at_period,  :null => false, :default => 'AM'
      t.string  :closes_at,        :null => false
      t.string  :closes_at_period, :null => false, :default => 'PM'

      t.timestamps
    end

    add_index :office_hours, :property_id
    add_index :office_hours, [:property_id, :day], :unique => true
  end

  def self.down
    drop_table :office_hours
  end
end
