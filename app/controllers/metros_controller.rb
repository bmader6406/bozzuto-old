class MetrosController < ApplicationController
  def index
  end

  def show
  end


  private

  def metros
    @metros ||= Metro.positioned.all
  end
  helper_method :metros

  def metro
    @metro ||= Metro.find(params[:id])
  end
  helper_method :metro
end
