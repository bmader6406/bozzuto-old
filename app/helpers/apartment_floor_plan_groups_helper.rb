module ApartmentFloorPlanGroupsHelper
  def floor_plan_group_link(community, group, bedrooms)
    url = if group == ApartmentFloorPlanGroup.penthouse
      community.availability_url
    else
      community.availability_url + 
        (community.availability_url.match(/\?/) ? '&' : '?') +
        "beds=#{bedrooms}"
    end
    link_to 'View More', url
  end

  def render_floor_plan_group_mobile_listings(community, exclude_group = nil)
    ''.tap do |output|
      floor_plan_presenter(community).groups.each do |group|
        if group.has_plans? && group != exclude_group
          output << render(:partial => 'apartment_floor_plan_groups/listing',
            :locals => { 
              :community => community,
              :group     => group
          }).to_s
        end
      end
    end.html_safe
  end
end
