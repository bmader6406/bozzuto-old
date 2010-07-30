class CreateJoinTableForSectionAndNewsAndPressModels < ActiveRecord::Migration
  def self.up
    create_table :awards_sections, :id => false do |t|
      t.integer :award_id
      t.integer :section_id
    end
    add_index :awards_sections, [:section_id, :award_id]
    add_index :awards_sections, [:award_id, :section_id]


    create_table :news_posts_sections, :id => false do |t|
      t.integer :news_post_id
      t.integer :section_id
    end
    add_index :news_posts_sections, [:section_id, :news_post_id]
    add_index :news_posts_sections, [:news_post_id, :section_id]


    create_table :press_releases_sections, :id => false do |t|
      t.integer :press_release_id
      t.integer :section_id
    end
    add_index :press_releases_sections, [:section_id, :press_release_id]
    add_index :press_releases_sections, [:press_release_id, :section_id]
  end

  def self.down
    drop_table :awards_sections
    drop_table :news_posts_sections
    drop_table :press_releases_sections
  end
end
