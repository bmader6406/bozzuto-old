class MigrateApartmentCommunityRecordsFromPropertiesToApartmentCommunities < ActiveRecord::Migration
  def up
    Bozzuto::Data::ModelMigrator.new(
      origin_class:         Property,
      target_class:         ApartmentCommunity,
      records:              Property.where(type: 'ApartmentCommunity').map { |p| p.becomes(Property) },
      skip_validations_for: %i(position featured_position slug office_hours phone_number mobile_phone_number)
    ).migrate
  end

  def down
    ApartmentCommunity.destroy_all
  end
end
