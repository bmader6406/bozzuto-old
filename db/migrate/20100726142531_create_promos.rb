class CreatePromos < ActiveRecord::Migration
  def self.up
    create_table :promos do |t|
      t.string :title, :null => false
      t.string :subtitle
      t.string :link_url

      t.timestamps
    end
  end

  def self.down
    drop_table :promos
  end
end
