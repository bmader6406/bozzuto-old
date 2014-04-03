class MetrosController < ApplicationController
  has_mobile_actions :index, :show

  def index
  end

  def show
  end


  private

  def states
    @states ||= State.positioned
  end
  helper_method :states

  def metros
    @metros ||= Metro.positioned
  end
  helper_method :metros

  def metro
    @metro ||= Metro.find(params[:id])
  end
  helper_method :metro

  def areas
    @areas ||= metro.areas.positioned
  end
  helper_method :areas
end
