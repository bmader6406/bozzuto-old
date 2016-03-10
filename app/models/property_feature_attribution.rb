class PropertyFeatureAttribution < ActiveRecord::Base
  belongs_to :property, polymorphic: true, inverse_of: :property_feature_attributions
  belongs_to :property_feature,            inverse_of: :property_feature_attributions

  validates :property,
            :property_feature,
            presence: true
end
