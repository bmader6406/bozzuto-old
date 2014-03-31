module ApartmentFloorPlansHelper
  def floor_plan_presenter(thing)
    @floor_plan_presenters ||= {}

    @floor_plan_presenters[thing] ||= Bozzuto::ApartmentFloorPlans::Presenter.new(thing)
  end
end
