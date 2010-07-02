class CreateHomePages < ActiveRecord::Migration
  def self.up
    create_table :home_pages do |t|
      t.text    :body
      t.integer :featured_property_id

      t.timestamps
    end
  end

  def self.down
    drop_table :home_pages
  end
end
