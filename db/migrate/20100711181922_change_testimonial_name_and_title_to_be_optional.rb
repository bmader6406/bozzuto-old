class ChangeTestimonialNameAndTitleToBeOptional < ActiveRecord::Migration
  def self.up
    change_column :testimonials, :name, :string, :null => true
    change_column :testimonials, :title, :string, :null => true
  end

  def self.down
    change_column :testimonials, :name, :string, :null => false
    change_column :testimonials, :title, :string, :null => false
  end
end
