class CreateJoinTableForProjectCategories < ActiveRecord::Migration
  def self.up
    create_table :project_categories_projects, :id => false do |t|
      t.integer :project_category_id
      t.integer :project_id
    end

    add_index :project_categories_projects, [:project_category_id, :project_id]
    add_index :project_categories_projects, [:project_id, :project_category_id]
  end

  def self.down
    drop_table :project_categories_projects
  end
end
