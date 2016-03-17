class MigrateHomeCommunityRecordsFromPropertiesToHomeCommunities < ActiveRecord::Migration
  def up
    Bozzuto::Data::ModelMigrator.new(
      origin_class:         Property,
      target_class:         HomeCommunity,
      records:              Property.where(type: 'HomeCommunity').map { |p| p.becomes(Property) },
      skip_validations_for: %i(position slug office_hours phone_number mobile_phone_number)
    ).migrate
  end

  def down
    HomeCommunity.destroy_all
  end
end
