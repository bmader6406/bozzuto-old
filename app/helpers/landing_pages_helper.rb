module LandingPagesHelper
  def popular_property_class(property)
    property.class.to_s.underscore.gsub(/_/, '-')
  end
end
