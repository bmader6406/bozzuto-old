class ApartmentFloorPlanObserver < ActiveRecord::Observer
  def after_save(plan)
    cache_cheapest_price_on_community(plan)
  end

  def after_destroy(plan)
    cache_cheapest_price_on_community(plan)
  end


  private

  def cache_cheapest_price_on_community(plan)
    group     = plan.floor_plan_group
    community = plan.apartment_community

    group_name = case plan.floor_plan_group
    when ApartmentFloorPlanGroup.studio         then 'studio'
    when ApartmentFloorPlanGroup.one_bedroom    then '1_bedroom'
    when ApartmentFloorPlanGroup.two_bedrooms   then '2_bedroom'
    when ApartmentFloorPlanGroup.three_bedrooms then '3_bedroom'
    when ApartmentFloorPlanGroup.penthouse      then 'penthouse'
    else return
    end
    field = "cheapest_#{group_name}_price"

    cheapest_price = community.floor_plans.in_group(group).non_zero_min_rent.minimum(:min_rent)

    community.update_attributes(field => cheapest_price)
  end
end
