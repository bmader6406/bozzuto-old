class ChangePhotoFieldsForFlickr < ActiveRecord::Migration
  def self.up
    rename_column :photos, :caption, :title

    remove_column :photos, :apartment_community_id

    rename_column :photos, :image, :image_file_name
    change_column :photos, :image_file_name, :string, :null => true

    add_column :photos, :image_content_type, :string

    add_column :photos, :flickr_photo_id, :string, :null => false

    add_column :photos, :photo_set_id, :integer

    add_column :photos, :position, :integer
  end

  def self.down
    rename_column :photos, :title, :caption

    add_column :photos, :apartment_community_id, :integer, :null => false

    rename_column :photos, :image_file_name, :image
    change_column :photos, :image, :string, :null => false

    remove_column :photos, :image_content_type

    remove_column :photos, :flickr_photo_id

    remove_column :photos, :photo_set_id

    remove_column :photos, :position
  end
end
