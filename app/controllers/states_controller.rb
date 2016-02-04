class StatesController < ApplicationController
  has_mobile_actions :show


  private

  def state
    @state ||= State.find_by!(code: params[:id])
  end
  helper_method :state
end
