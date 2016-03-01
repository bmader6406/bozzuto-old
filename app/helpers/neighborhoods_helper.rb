module NeighborhoodsHelper
  def neighborhoods_assets
    content_for :stylesheet do
      stylesheet_link_tag 'neighborhoods', :media => 'screen'
    end

    content_for :javascript do
      javascript_include_tag 'neighborhoods'
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
