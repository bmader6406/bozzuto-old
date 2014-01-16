module ApartmentFloorPlansHelper
  def floor_plan_presenter(community)
    @floor_plan_presenters ||= {}

    @floor_plan_presenters[community] ||= Bozzuto::ApartmentFloorPlanPresenter.new(community)
  end
end
