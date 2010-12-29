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

  def render_floor_plan_group_mobile_listings(groups, community = nil)
    options = {
      :partial    => 'apartment_floor_plan_groups/listing',
      :collection => groups,
      :as         => :group,
      :locals     => { :community => community }
    }

    render options
  end
end
