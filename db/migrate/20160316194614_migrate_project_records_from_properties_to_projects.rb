class MigrateProjectRecordsFromPropertiesToProjects < ActiveRecord::Migration
  def up
    Bozzuto::Data::ModelMigrator.new(
      origin_class:         Property,
      target_class:         Project,
      records:              Property.where(type: 'Project').map { |p| p.becomes(Property) },
      skip_validations_for: %i(position slug)
    ).migrate
  end

  def down
    Project.destroy_all
  end
end
