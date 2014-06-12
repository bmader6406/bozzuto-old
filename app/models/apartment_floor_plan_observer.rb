class ApartmentFloorPlanObserver < ActiveRecord::Observer
  def after_save(plan)
    update_cache(plan)
  end

  def after_destroy(plan)
    update_cache(plan)
  end


  private

  def update_cache(plan)
    community = plan.apartment_community

    community.invalidate_apartment_floor_plan_cache!
  end
end
