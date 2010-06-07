module FloorPlanGroupsHelper
  def floor_plan_bedrooms(plan)
    pluralize(plan.bedrooms, 'Bedroom')
  end

  def floor_plan_bathrooms(plan)
    bathrooms = if plan.bathrooms.frac.to_f == 0.0
      plan.bathrooms.to_i
    else
      plan.bathrooms.to_f
    end
    pluralize(bathrooms, 'Bathroom')
  end
end
