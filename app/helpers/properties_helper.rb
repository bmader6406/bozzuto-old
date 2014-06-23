module PropertiesHelper
  def mobile_map_url(property)
    "http://maps.google.com/maps?q=#{property.address}"
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
      lis = community.property_features.map do |feature|
        if feature.icon?
          content_tag(:li) do
            link_to feature.name, "##{dom_id(feature)}",
              :style              => "background-image: url(#{feature.icon.url});",
              :'data-name'        => feature.name,
              :'data-description' => feature.description
          end
        end
      end

      lis.compact.join.html_safe
    end
  end

  def property_bullets
    if @community.has_overview_bullets?
      content_tag :ul, :class => 'cty-features-list' do
        lis = (1..3).map do |i|
          if @community.send("overview_bullet_#{i}").present?
            content_tag(:li) { @community.send("overview_bullet_#{i}") }
          end
        end

        lis.compact.join.html_safe
      end
    end
  end
end
