class CopyPropertiesPropertyFeaturesToAttributions < ActiveRecord::Migration
  def up
    records.each do |record|
      PropertyFeatureAttribution.create(
        property_id:         record.property_id,
        property_type:       record.property_type,
        property_feature_id: record.property_feature_id
      )
    end
  end
  
  def down
    PropertyFeatureAttribution.destroy_all
  end

  private

  def results
    @results ||= execute <<-SQL
      SELECT properties_property_features.*, properties.type AS property_type
      FROM properties_property_features
      JOIN properties
      ON properties_property_features.property_id = properties.id
    SQL
  end

  def klass
    @klass ||= Struct.new(*results.fields.map(&:to_sym))
  end

  def records
    results.map { |values| klass.new(*values) }
  end

  PropertyFeatureAttribution = Class.new(ActiveRecord::Base)
end
