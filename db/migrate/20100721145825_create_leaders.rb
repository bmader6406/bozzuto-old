class CreateLeaders < ActiveRecord::Migration
  def self.up
    create_table :leaders do |t|
      t.string :name, :null => false
      t.string :title, :null => false
      t.string :company, :null => false
      t.integer :leadership_group_id, :null => false
      t.text :bio, :null => false
      t.integer :position
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.timestamps
    end
  end

  def self.down
    drop_table :leaders
  end
end
