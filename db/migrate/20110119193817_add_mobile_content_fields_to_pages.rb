class AddMobileContentFieldsToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :mobile_body, :text
    add_column :pages, :mobile_body_extra, :text
  end

  def self.down
    remove_column :pages, :mobile_body
    remove_column :pages, :mobile_body_extra
  end
end
