class CreateCommunityLinks < ActiveRecord::Migration
  def self.up
    create_table :community_links do |t|
      t.with_options :null => false do |n|
        n.string :title
        n.string :url
        n.integer :community_id
      end

      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :community_links
  end
end
