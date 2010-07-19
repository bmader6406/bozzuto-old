class AddPositionToProjects < ActiveRecord::Migration
  def self.up
    add_column :properties, :position, :integer, :null => true

    Section.all.each do |section|
      i = 0
      section.projects.find(:all, :order => 'title ASC').each do |project|
        i += 1
        project.update_attribute('position', i)        
      end
    end
  end

  def self.down
    remove_column :properties, :position
  end
end
