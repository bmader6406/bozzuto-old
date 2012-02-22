class AddPolymorphicTypeToCarousel < ActiveRecord::Migration
  def self.up
    rename_column :carousels, :page_id, :content_id
    add_column :carousels, :content_type, :string

    execute "UPDATE carousels SET content_type = 'Page'"

    add_index :carousels, [:content_type, :content_id]
  end

  def self.down
    remove_index :carousels, [:content_type, :content_id]

    rename_column :carousels, :content_id, :page_id
    remove_column :carousels, :content_type
  end
end
