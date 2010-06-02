module CommunitiesHelper
  def community_icons
    content_tag :ul, :class => "community-icons" do
      %w(elite smart_share smart_rent green non_smoking).inject("") do |html, flag|
        if @community.send("#{flag}?")
          html << content_tag(:li, :class => flag.gsub(/_/, '-')) do
            link_to "#" do
              content_tag(:span) { Community.human_attribute_name(flag) }
            end
          end
        end
        html
      end.html_safe
    end
  end

  def floor_plan_price(plan)
    number_to_currency(plan.price / 100)
  end
end
