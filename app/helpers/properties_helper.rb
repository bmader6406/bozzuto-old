module PropertiesHelper
  def mobile_map_url(property)
    lat = property.latitude
    lon = property.longitude

    case device
    when :android
      "geo:#{lat},#{lon}"
    when :blackberry
      if property.is_a?(HomeCommunity)
        home_community_office_hours_path(property)
      else
        apartment_community_office_hours_path(property)
      end
    else
      "http://maps.google.com/maps?q=#{lat},#{lon}"
    end
  end

  def directions_url(address)
    "http://maps.google.com/maps?daddr=#{URI.encode(address)}"
  end

  def brochure_link(property, opts = {})
    if property.brochure_link_text.present?
      url = if property.uses_brochure_url?
        property.brochure_url
      else
        property.brochure.url
      end
      
      if url.present?
        link_to property.brochure_link_text, url, { :rel => 'external' }.merge(opts)
      end
    end
  end

  def property_icons(community)
    content_tag :ul, :class => 'community-icons' do
      community.property_features.map do |feature|
        if feature.icon?
          content_tag(:li) do
            link_to feature.name, "##{dom_id(feature)}",
              :style              => "background-image: url(#{feature.icon.url});",
              :'data-name'        => feature.name,
              :'data-description' => feature.description
          end
        end
      end.compact.join.html_safe
    end
  end

  def property_bullets
    if @community.has_overview_bullets?
      content_tag :ul do
        (1..3).map do |i|
          if @community.send("overview_bullet_#{i}").present?
            content_tag(:li) { @community.send("overview_bullet_#{i}") }
          end
        end.compact.join.html_safe
      end
    end
  end
end
