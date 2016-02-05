module ApartmentFloorPlanGroupsHelper
  def floor_plan_group_link(community, group, bedrooms)
    #:nocov:
    url = community.availability_url

    if group != ApartmentFloorPlanGroup.penthouse
      splitter  = url.include?('?') ? '&' : '?'
      url      += "#{splitter}beds=#{bedrooms}"
    end

    link_to 'View More', url
    #:nocov:
  end

  def render_floor_plan_group_mobile_listings(community, exclude_group = nil)
    #:nocov:
    ''.tap do |output|
      floor_plan_presenter(community).groups.each do |group|
        if group.has_plans? && group != exclude_group
          output << render(
            partial:   'apartment_floor_plan_groups/listing',
            formats:   %i(mobile),
            locals: {
              community: community,
              group:     group
            }
          ).to_s
        end
      end
    end.html_safe
    #:nocov:
  end
end
