class CopyProjectTypePropertyRecordsToProjectsTable < ActiveRecord::Migration
  def up
    Bozzuto::Data::ModelMigrator.new(
      origin_class:         Property,
      target_class:         Project,
      records:              Property.where(type: 'Project').map { |p| p.becomes(Property) },
      skip_validations_for: [:position, :slug]
    ).migrate
  end

  def down
    # no op
  end

  Property = Class.new(ActiveRecord::Base) unless defined?(Property)
  Project  = Class.new(ActiveRecord::Base) unless defined?(Project)
end
