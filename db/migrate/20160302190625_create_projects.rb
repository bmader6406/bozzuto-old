class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string  :title, null: false
      t.string  :slug
      t.string  :short_title
      t.string  :short_description
      t.string  :page_header
      t.string  :section
      t.string  :section_id
      t.string  :street_address
      t.integer :city_id
      t.integer :county_id
      t.string  :zip_code
      t.decimal :latitude,  precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.string  :website_url
      t.string  :website_url_text
      t.string  :video_url
      t.integer :brochure_type
      t.string  :brochure_url
      t.string  :brochure_file_name
      t.string  :brochure_content_type
      t.string  :brochure_link_text
      t.string  :listing_image_file_name
      t.string  :listing_image_content_type
      t.string  :listing_title
      t.text    :listing_text
      t.text    :overview_text
      t.date    :completion_date,     null: false
      t.boolean :has_completion_date, null: false, default: false
      t.boolean :published,           null: false, deafult: false
      t.boolean :featured_mobile,     null: false, default: false
      t.integer :position
    end
  end
end
