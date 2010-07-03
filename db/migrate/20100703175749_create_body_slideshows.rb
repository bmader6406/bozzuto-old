class CreateBodySlideshows < ActiveRecord::Migration
  def self.up
    create_table :body_slideshows do |t|
      t.string :name, :null => false
      t.integer :page_id

      t.timestamps
    end
  end

  def self.down
    drop_table :body_slideshows
  end
end
