class ApartmentFloorPlanObserver < ActiveRecord::Observer
  def after_save(plan)
    cache_cheapest_price_on_community(plan)
    cache_plan_count_on_community(plan)
  end

  def after_destroy(plan)
    cache_cheapest_price_on_community(plan)
    cache_plan_count_on_community(plan)
  end


  private

  def cache_cheapest_price_on_community(plan)
    group          = plan.floor_plan_group
    community      = plan.apartment_community

    if community
      cheapest_price = community.
                        available_floor_plans.
                        in_group(group).
                        with_cheapest_rent.
                        try(:min_rent)

      community.update_attributes("cheapest_#{group.name_for_cache}_price" => cheapest_price)
    end
  end

  def cache_plan_count_on_community(plan)
    group     = plan.floor_plan_group
    community = plan.apartment_community

    if community
      count = community.
                available_floor_plans.
                in_group(group).
                count

      community.update_attributes("plan_count_#{group.name_for_cache}" => count)
    end
  end
end
