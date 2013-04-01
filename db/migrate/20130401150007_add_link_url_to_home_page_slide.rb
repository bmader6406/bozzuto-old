class AddLinkUrlToHomePageSlide < ActiveRecord::Migration
  def self.up
    add_column :home_page_slides, :link_url, :string
  end

  def self.down
    remove_column :home_page_slides, :link_url
  end
end
