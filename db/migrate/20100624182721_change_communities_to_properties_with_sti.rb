class ChangeCommunitiesToPropertiesWithSti < ActiveRecord::Migration
  class Property < ActiveRecord::Base; end

  def self.up
    rename_table :communities, :properties
    add_column :properties, :type, :string

    Property.all.each do |property|
      property.type = 'Community'
      property.save
    end
  end

  def self.down
    remove_column :properties, :type
    rename_table :properties, :communities
  end
end
