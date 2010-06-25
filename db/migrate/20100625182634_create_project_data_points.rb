class CreateProjectDataPoints < ActiveRecord::Migration
  def self.up
    create_table :project_data_points do |t|
      t.with_options :null => false do |n|
        n.string  :name
        n.string  :data
        n.integer :project_id
      end

      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :project_data_points
  end
end
