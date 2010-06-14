class CreateTestimonials < ActiveRecord::Migration
  def self.up
    create_table :testimonials do |t|
      t.string :name,  :null => false
      t.string :title, :null => false
      t.text   :quote, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :testimonials
  end
end
