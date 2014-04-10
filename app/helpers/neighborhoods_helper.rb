module NeighborhoodsHelper
  def neighborhoods_assets
    content_for :stylesheet do
      include_stylesheets :neighborhoods, :media => 'screen'
    end

    content_for :javascript do
      include_javascripts :neighborhoods
    end
  end

  def render_neighborhoods_listing(thing)
    template, options = nil, {}

    if thing.is_a?(ApartmentCommunity)
      template = 'neighborhoods/community_listing'
      options  = { :community => thing }
    else
      template = "#{thing.class.to_s.tableize}/listing"
      options  = thing.lineage_hash
    end

    render(template, options)
  end
end
