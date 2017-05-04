class AddFieldsToHomePage < ActiveRecord::Migration
  def change
    add_column :home_pages, :headline,              :string
    add_column :home_pages, :apartment_subheadline, :string
    add_column :home_pages, :home_subheadline,      :string
  end
end
