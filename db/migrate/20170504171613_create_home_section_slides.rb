class CreateHomeSectionSlides < ActiveRecord::Migration
  def change
    create_table :home_section_slides do |t|
      t.integer :home_page_id,       null: false
      t.integer :position
      t.string  :image_file_name,    null: false
      t.string  :image_content_type
      t.string  :text
      t.string  :link_url,           null: false

      t.timestamps null: false
    end

    add_index :home_section_slides, :home_page_id

    add_foreign_key :home_section_slides, :home_pages, on_delete: :cascade
  end
end
