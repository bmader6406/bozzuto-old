class HospitalMembership < ActiveRecord::Base
  belongs_to :hospital
  belongs_to :apartment_community

  after_save :update_distance_from_hospital
  
  validates_presence_of :apartment_community_id
  validates_presence_of :hospital_id
  validates_uniqueness_of :apartment_community_id, :scope => :hospital_id

  def show_distance
    miles(distance)
  end

  def recalculate_distance
    update_distance_from_hospital
  end

  private

  def miles(distance)
    "#{distance.round(1)} miles"
  end

  def update_distance_from_hospital
    dist = calculate_distance
    update_columns(distance: dist)
  end

  def calculate_distance
    origin = fetch_lat_lon(hospital)
    destination = fetch_lat_lon(apartment_community)
    call_distance_matrix_api(origin, destination)
  end

  def fetch_lat_lon(thing)
    if thing.latitude && thing.longitude
      [thing.latitude, thing.longitude]
    else
      [nil, nil]
    end
  end

  def call_distance_matrix_api(origin, destination)
    result = GoogleMapsAPI::DistanceMatrix.calculate([origin], [destination],  
                                                      options = {
                                                        key: APP_CONFIG[:google_maps_api_key], 
                                                        https: true
                                                      }
                                                    )
    if result.rows[0] && result.rows[0].elements[0].status == "OK"
      result.rows[0].elements[0].distance.value * 0.000621371 # converting to miles
    else
      0
    end
  end
end
