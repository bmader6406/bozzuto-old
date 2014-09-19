module OverriddenPathsHelper
  def property_path(property, options = nil)
    case property
    when Project
      project_path(property.section, property, options)
    when ApartmentCommunity
      apartment_community_path(property, options)
    when HomeCommunity
      home_community_path(property, options)
    end
  end

  %w(url path).each do |type|
    define_method "schedule_tour_community_#{type}" do |property|
      if property.schedule_tour_url?
        property.schedule_tour_url
      else
        send("contact_community_#{type}", property)
      end
    end

    define_method "contact_community_#{type}" do |property|
      send("#{property.class.model_name.singular}_contact_#{type}", property)
    end
  end

  def place_path(place, opts = {})
    send("#{place.class.to_s.underscore}_path", *[place.lineage, opts].flatten)
  end
end
