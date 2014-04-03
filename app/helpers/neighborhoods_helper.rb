module NeighborhoodsHelper
  def neighborhoods_assets
    content_for :stylesheet do
      include_stylesheets :neighborhoods, :media => 'screen'
    end

    content_for :javascript do
      include_javascripts :neighborhoods
    end
  end
end
