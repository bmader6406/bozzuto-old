class CreateJoinTableForProjectCategories < ActiveRecord::Migration
  def self.up
    create_table :project_categories_projects, :id => false do |t|
      t.integer :project_category_id
      t.integer :project_id
    end

    add_index :project_categories_projects, [:project_category_id, :project_id], :name => 'index_project_categories_and_projects'
    add_index :project_categories_projects, [:project_id, :project_category_id], :name => 'index_projects_and_project_categories'
  end

  def self.down
    drop_table :project_categories_projects
  end
end
