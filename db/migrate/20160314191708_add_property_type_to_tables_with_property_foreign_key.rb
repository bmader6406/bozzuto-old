class AddPropertyTypeToTablesWithPropertyForeignKey < ActiveRecord::Migration
  def change
    add_column :property_slideshows,            :property_type, :string
    add_column :property_features_pages,        :property_type, :string
    add_column :property_neighborhood_pages,    :property_type, :string
    add_column :property_contact_pages,         :property_type, :string
    add_column :property_tours_pages,           :property_type, :string
    add_column :property_retail_pages,          :property_type, :string
    add_column :photos,                         :property_type, :string
    add_column :videos,                         :property_type, :string
    add_column :body_slides,                    :property_type, :string
    add_column :dnr_configurations,             :property_type, :string
    add_column :landing_page_popular_orderings, :property_type, :string
    add_column :office_hours,                   :property_type, :string
    add_column :property_amenities,             :property_type, :string
  end
end
