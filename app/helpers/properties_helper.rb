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

  def send_to_phone_mediaplex_code(community)
    mediaplex_id = CGI::escape("#{community.id}-#{Time.new.to_i}")

    if community.is_a? HomeCommunity
      <<-END.html_safe
        <iframe src="http://img-cdn.mediaplex.com/0/16797/universal.html?page_name=bozzuto_homes_send_to_phone&Bozzuto_Homes_Send_To_Phone=1&mpuid=#{mediaplex_id}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
      END
    elsif community.is_a? ApartmentCommunity
      <<-END.html_safe
        <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=apartments_send_to_phone&Apartments_Send_to_Phone=1&mpuid=#{mediaplex_id}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
      END
    end
  end

  def send_to_friend_mediaplex_code(community, email)
    mediaplex_id = CGI::escape("#{email}-#{Time.new.to_i}")

    if email.present?
      if community.is_a? HomeCommunity
        <<-END.html_safe
          <iframe src="http://img-cdn.mediaplex.com/0/16797/universal.html?page_name=bozzuto_homes_send_to_friend&Bozzuto_Homes_Send_To_Friend=1&mpuid=#{mediaplex_id}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
        END
      elsif community.is_a? ApartmentCommunity
        <<-END.html_safe
          <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=apartments_send_to_friend&Apartments_Send_to_Friend=1&mpuid=#{mediaplex_id}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
        END
      end
    end
  end
end
