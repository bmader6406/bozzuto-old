class ApartmentFloorPlanObserver < ActiveRecord::Observer
  def after_save(plan)
    update_caches(plan)
  end

  def after_destroy(plan)
    update_caches(plan)
  end


  private

  def update_caches(plan)
    community = plan.apartment_community
    group     = plan.floor_plan_group

    if community
      community.send(:cache_cheapest_price, group)
      community.send(:cache_plan_count, group)
      community.send(:cache_min_and_max_rents)
    end
  end
end
