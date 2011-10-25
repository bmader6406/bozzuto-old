class AddVideoUrlToBodySlide < ActiveRecord::Migration
  def self.up
    add_column :body_slides, :video_url, :string
  end

  def self.down
    remove_column :body_slides, :video_url
  end
end
