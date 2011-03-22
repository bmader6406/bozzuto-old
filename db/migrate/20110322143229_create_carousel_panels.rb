class CreateCarouselPanels < ActiveRecord::Migration
  def self.up
    create_table :carousel_panels do |t|
      t.integer :position, :null => false
      t.integer :carousel_id, :null => false

      t.string :image_file_name
      t.string :image_content_type

      t.string :link_url, :null => false
      t.string :heading
      t.string :caption

      t.timestamps
    end
  end

  def self.down
    drop_table :carousel_panels
  end
end
