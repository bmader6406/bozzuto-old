class CreatePublications < ActiveRecord::Migration
  def self.up
    create_table :publications do |t|
      t.string  :name, :null => false
      t.text    :description
      t.integer :position

      t.string  :image_file_name, :null => false
      t.string  :image_content_type, :null => false

      t.boolean :published, :default => false

      t.timestamps
    end

    add_index :publications, [:published, :position]
  end

  def self.down
    drop_table :publications
  end
end
