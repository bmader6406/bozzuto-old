class StatesController < ApplicationController
  layout 'homepage'

  def show
    @state    = State.find_by_code(params[:id])
    @cities   = @state.cities.ordered_by_name
    @counties = @state.counties.ordered_by_name
  end
end
