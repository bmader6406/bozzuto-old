class AddJoinTablesForLandingPage < ActiveRecord::Migration
  def self.up
    # popular properties
    create_table :landing_pages_popular_properties, :id => false do |t|
      t.integer :landing_page_id
      t.integer :property_id
    end
    add_index :landing_pages_popular_properties, [:landing_page_id, :property_id]

    # home communities
    create_table :home_communities_landing_pages, :id => false do |t|
      t.integer :landing_page_id
      t.integer :home_community_id
    end
    add_index :home_communities_landing_pages, [:landing_page_id, :home_community_id]

    # apartment communities
    create_table :apartment_communities_landing_pages, :id => false do |t|
      t.integer :landing_page_id
      t.integer :apartment_community_id
    end
    add_index :apartment_communities_landing_pages, [:landing_page_id, :apartment_community_id]

    # featured apartment communities
    create_table :featured_apartment_communities_landing_pages, :id => false do |t|
      t.integer :landing_page_id
      t.integer :apartment_community_id
    end
    add_index :apartment_communities_landing_pages, [:landing_page_id, :apartment_community_id]

    # upcoming projects
    create_table :landing_pages_projects, :id => false do |t|
      t.integer :landing_page_id
      t.integer :project_id
    end
    add_index :landing_pages_projects, [:landing_page_id, :project_id]
  end

  def self.down
    # popular properties
    drop_table :landing_pages_popular_properties

    # home communities
    drop_table :home_communities_landing_pages

    # apartment communities
    drop_table :apartment_communities_landing_pages

    # featured apartment communities
    drop_table :featured_apartment_communities_landing_pages

    # upcoming projects
    drop_table :landing_pages_projects
  end
end
