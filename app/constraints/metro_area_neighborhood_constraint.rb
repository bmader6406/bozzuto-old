class MetroAreaNeighborhoodConstraint

  def self.matches?(request)
    new(request).matches?
  end

  def initialize(request)
    @request = request
  end

  def matches?
    metro_exists? &&
      area_exists? &&
      neighborhood_exists?
  end

  private

  attr_reader :request

  def metro_exists?
    Metro.friendly.exists?(metro_id)
  end

  def metro_id
    request.params[:metro_id]
  end

  def area_exists?
    Area.friendly.exists?(area_id)
  end

  def area_id
    request.params[:area_id]
  end

  def neighborhood_exists?
    Neighborhood.friendly.exists?(neighborhood_id)
  end

  def neighborhood_id
    request.params[:id]
  end
end
