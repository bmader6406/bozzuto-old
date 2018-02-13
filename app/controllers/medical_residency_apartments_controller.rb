class MedicalResidencyApartmentsController < ApplicationController
  has_mobile_actions :show

  def show
  end

  private

  def region
  	@region = HospitalRegion.includes(
                hospitals: [:apartment_communities, hospital_memberships: [:apartment_community, :hospital]]
              ).friendly.find(params[:id])
  end
  helper_method :region

  def hospitals
  	@hospitals = region.hospitals.position_asc.select(&:has_communities?)
  end
  helper_method :hospitals

end
