class RemoveExistingProjectTypeProperties < ActiveRecord::Migration
  def up
    Property.where(type: 'Project').find_each do |property|
      property.becomes(Property).destroy
    end
  end

  def down
    # no op
  end

  Property = Class.new(ActiveRecord::Base) unless defined?(Property)
end
