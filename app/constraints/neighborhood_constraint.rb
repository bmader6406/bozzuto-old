class NeighborhoodConstraint

  def self.matches?(request)
    new(request).matches?
  end

  def initialize(request)
    @request = request
  end

  def matches?
    neighborhood_exists?
  end

  private

  attr_reader :request

  def neighborhood_exists?
    Neighborhood.friendly.exists?(neighborhood_id)
  end

  def neighborhood_id
    request.params[:id]
  end
end
