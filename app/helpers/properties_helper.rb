module PropertiesHelper
  def brochure_link(property)
    if property.brochure_link_text.present?
      url = if property.uses_brochure_url?
        property.brochure_url
      else
        property.brochure.url
      end
      
      if url.present?
        link_to property.brochure_link_text, url, :target => "_blank"
      end
    end
  end

  def property_icons(community)
    content_tag :ul, :class => 'community-icons' do
      community.property_features.inject('') do |output, feature|
        if feature.icon?
          output << content_tag(:li) do
            link_to feature.name, "##{dom_id(feature)}", :style => "background-image: url(#{feature.icon.url});"
          end
        end
        output.html_safe
      end
    end
  end

  def property_icon_descriptions
    content_tag :ul, :id => 'icon-tooltips' do
      PropertyFeature.all.inject('') do |output, feature|
        output << content_tag(:li, :id => dom_id(feature)) do
          content_tag(:h4) { feature.name } + 
            content_tag(:p) { feature.description }
        end
        output.html_safe
      end
    end
  end

  def property_bullets
    if @community.has_overview_bullets?
      content_tag :ul do
        (1..3).inject('') do |output, i|
          output << if @community.send("overview_bullet_#{i}").present?
            content_tag(:li) { @community.send("overview_bullet_#{i}") }
          end
          output.html_safe
        end
      end.html_safe
    end
  end
end
