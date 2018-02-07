class MedicalResidencyApartmentsController < ApplicationController
  def show
  end

  private

  def region
  	@region = HospitalRegion.friendly.find(params[:id])
  end
  helper_method :region

  def hospitals
  	@hospitals = region.hospitals.position_asc.select(&:has_communities?)
  end
  helper_method :hospitals

end
