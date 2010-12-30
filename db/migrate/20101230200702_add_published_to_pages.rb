class AddPublishedToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :published, :boolean, :default => false, :null => false
    Page.all.each do |page|
      page.update_attribute(:published, true)
    end
  end

  def self.down
    remove_column :pages, :published
  end
end
