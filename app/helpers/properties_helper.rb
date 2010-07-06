module PropertiesHelper
  def property_icons
    content_tag :ul, :class => "community-icons" do
      %w(elite smart_share smart_rent green non_smoking).inject("") do |html, flag|
        if @community.send("#{flag}?")
          html << content_tag(:li, :class => flag.gsub(/_/, '-')) do
            link_to "#" do
              content_tag(:span) { ApartmentCommunity.human_attribute_name(flag) }
            end
          end
        end
        html
      end.html_safe
    end
  end

  def property_bullets
    if @community.has_overview_bullets?
      content_tag :ul do
        (1..3).inject('') do |output, i|
          output += if @community.send("overview_bullet_#{i}").present?
            content_tag(:li) { @community.send("overview_bullet_#{i}") }
          end
          output.html_safe
        end
      end.html_safe
    end
  end
end
