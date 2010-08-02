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

  def floor_plan_group_pluralize(count, name)
    count == 1 ? name.singularize : name.pluralize
  end
end
