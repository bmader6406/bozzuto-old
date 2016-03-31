class HomeNeighborhoodConstraint

  def self.matches?(request)
    new(request).matches?
  end

  def initialize(request)
    @request = request
  end

  def matches?
    home_neighborhood_exists?
  end

  private

  attr_reader :request

  def home_neighborhood_exists?
    HomeNeighborhood.friendly.exists?(home_neighborhood_id)
  end

  def home_neighborhood_id
    request.params[:id]
  end
end
