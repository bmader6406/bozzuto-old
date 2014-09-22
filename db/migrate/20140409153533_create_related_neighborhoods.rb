class CreateRelatedNeighborhoods < ActiveRecord::Migration
  def self.up
    create_table :related_neighborhoods do |t|
      t.integer :neighborhood_id,        :null => false
      t.integer :nearby_neighborhood_id, :null => false
      t.integer :position

      t.timestamps
    end

    add_index :related_neighborhoods, :neighborhood_id
    add_index :related_neighborhoods, [:neighborhood_id, :nearby_neighborhood_id], :unique => true, :name => 'index_related_neighborhoods_on_id_and_related_id'
  end

  def self.down
    drop_table :related_neighborhoods
  end
end
