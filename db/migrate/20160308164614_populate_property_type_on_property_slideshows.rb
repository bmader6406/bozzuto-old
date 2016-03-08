class PopulatePropertyTypeOnPropertySlideshows < ActiveRecord::Migration
  def up
    PropertySlideshow.find_each do |slideshow|
      property = properties.find { |p| p.id == slideshow.property_id }
      
      if property.present?
        slideshow.update_column(:property_type, property.read_attribute(:type))
      end
    end
  end

  def down
    # no op
  end

  private

  def properties
    @properties ||= Property.all
  end

  Property          = Class.new(ActiveRecord::Base)
  PropertySlideshow = Class.new(ActiveRecord::Base)
end
