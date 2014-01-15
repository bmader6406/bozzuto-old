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
    ''.tap { |output|
      community.floor_plans_by_group.each do |group, plans_in_group|
        unless exclude_group && group == exclude_group
          output << render(:partial => 'apartment_floor_plan_groups/listing',
            :locals => { 
              :community => community,
              :group => group,
              :plans_in_group => plans_in_group
          }).to_s
        end
      end
    }.html_safe
  end
end
