class CreateProjectCategories < ActiveRecord::Migration
  def self.up
    create_table :project_categories do |t|
      t.string :title, :null => false
      t.string :cached_slug
      t.integer :position

      t.timestamps
    end

    add_index :project_categories, :cached_slug
  end

  def self.down
    drop_table :project_categories
  end
end
