class AddPageSpecificMetaFieldsToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :features_meta_title, :string
    add_column :properties, :features_meta_description, :string
    add_column :properties, :features_meta_keywords, :string

    add_column :properties, :media_meta_title, :string
    add_column :properties, :media_meta_description, :string
    add_column :properties, :media_meta_keywords, :string

    add_column :properties, :floor_plans_meta_title, :string
    add_column :properties, :floor_plans_meta_description, :string
    add_column :properties, :floor_plans_meta_keywords, :string

    add_column :properties, :neighborhood_meta_title, :string
    add_column :properties, :neighborhood_meta_description, :string
    add_column :properties, :neighborhood_meta_keywords, :string

    add_column :properties, :promotions_meta_title, :string
    add_column :properties, :promotions_meta_description, :string
    add_column :properties, :promotions_meta_keywords, :string

    add_column :properties, :contact_meta_title, :string
    add_column :properties, :contact_meta_description, :string
    add_column :properties, :contact_meta_keywords, :string
  end

  def self.down
    remove_column :properties, :features_meta_title
    remove_column :properties, :features_meta_description
    remove_column :properties, :features_meta_keywords

    remove_column :properties, :media_meta_title
    remove_column :properties, :media_meta_description
    remove_column :properties, :media_meta_keywords

    remove_column :properties, :floor_plans_meta_title
    remove_column :properties, :floor_plans_meta_description
    remove_column :properties, :floor_plans_meta_keywords

    remove_column :properties, :neighborhood_meta_title
    remove_column :properties, :neighborhood_meta_description
    remove_column :properties, :neighborhood_meta_keywords

    remove_column :properties, :promotions_meta_title
    remove_column :properties, :promotions_meta_description
    remove_column :properties, :promotions_meta_keywords

    remove_column :properties, :contact_meta_title
    remove_column :properties, :contact_meta_description
    remove_column :properties, :contact_meta_keywords
  end
end
