class CreateBuzzes < ActiveRecord::Migration
  def self.up
    create_table :buzzes do |t|
      t.string :email, :null => false
      t.string :first_name
      t.string :last_name
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :phone
      t.string :buzzes, :null => false
      t.string :affiliations, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :buzzes
  end
end
