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

  def render_floor_plan_group_mobile_listings(community, exclude_group = nil)
    community.floor_plans_by_group.each do |group, plans_in_group|
      unless exclude_group && group == exclude_group
        render :partial    => 'apartment_floor_plan_groups/listing',
               :locals     => { 
                 :community => community,
                 :group => group,
                 :places_in_group => plans_in_group
               }
      end
    end
  end
end
