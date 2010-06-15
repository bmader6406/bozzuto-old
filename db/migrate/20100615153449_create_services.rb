class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.with_options :null => false do |n|
        n.string  :title
        n.string  :slug
        n.integer :position
        n.integer :section_id
      end

      t.timestamps
    end
  end

  def self.down
    drop_table :services
  end
end
