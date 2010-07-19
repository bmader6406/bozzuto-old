class AddLinkToBodySlide < ActiveRecord::Migration
  def self.up
    add_column :body_slides, :link_url, :string
  end

  def self.down
    remove_column :body_slides, :link_url
  end
end
