class CreateCommunityPages < ActiveRecord::Migration
  def self.up
    create_table :community_pages do |t|
      t.with_options :null => false do |n|
        n.string :title
        n.text :content
        n.integer :community_id
      end

      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :community_pages
  end
end
