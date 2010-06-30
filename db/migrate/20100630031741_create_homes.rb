class CreateHomes < ActiveRecord::Migration
  def self.up
    create_table :homes do |t|
      t.with_options :null => false do |n|
        n.string  :name
        n.integer :bedrooms
        n.decimal :bathrooms, :precision => 3, :scale => 1
        n.integer :home_community_id
      end

      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :homes
  end
end
