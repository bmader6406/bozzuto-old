class AddSectionIdToTestimonial < ActiveRecord::Migration
  def self.up
    add_column :testimonials, :section_id, :integer
  end

  def self.down
    remove_column :testimonials, :section_id
  end
end
