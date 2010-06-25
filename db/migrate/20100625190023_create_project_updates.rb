class CreateProjectUpdates < ActiveRecord::Migration
  def self.up
    create_table :project_updates do |t|
      t.with_options :null => false do |n|
        n.text    :body
        n.integer :project_id
        n.boolean :published, :default => false
      end

      t.datetime :published_at

      t.timestamps
    end
  end

  def self.down
    drop_table :project_updates
  end
end
