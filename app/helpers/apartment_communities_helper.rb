module ApartmentCommunitiesHelper
  def render_apartments_listings(communities, locals = {})
    options = {
      :partial    => "apartment_communities/listing",
      :collection => communities,
      :as         => :community,
      :locals     => locals.reverse_merge({
        :use_dnr => false
      })
    }

    render options
  end

  def floor_plan_price(price)
    number_to_currency(price, :precision => 0) unless price.nil?
  end

  def price_of_cheapest_floor_plan(plans)
    cheapest_rent = plans.minimum(:min_rent)

    if cheapest_rent.present?
      raw(floor_plan_price(cheapest_rent))
    else
      ''
    end
  end

  def square_feet(plan)
    "#{plan.min_square_feet} Sq Ft"
  end

  def square_feet_of_largest_floor_plan(plans)
    largest = plans.largest.first

    if largest.present?
      square_feet(largest)
    else
      ''
    end
  end

  def floor_plan_image(plan)
    image = plan.actual_image
    thumb = plan.actual_thumb

    if image.present?
      link_to image_tag(thumb, :width => 160), image, :class => 'floor-plan-view'
    end
  end

  def website_url(url)
    url =~ /^http/ ? url : "http://#{url}"
  end

  def twitter_data_attr(handle)
    if handle.present?
      "data-twitter-username=\"#{handle}\"".html_safe
    end
  end

  def walkscore_map_script(community, opts = {})
    opts.reverse_merge!({
      :width  => 226,
      :height => 360
    })

    <<-END.html_safe
    <script type='text/javascript'>
    var ws_wsid = '#{APP_CONFIG[:walkscore_wsid]}';
    var ws_address = '#{community.address}';var ws_width = '#{opts[:width]}';var ws_height = '#{opts[:height]}';var ws_layout = 'vertical';var ws_background_color = '#fff';</script><style type='text/css'>#ws-walkscore-tile{position:relative;text-align:left;}#ws-walkscore-tile *{float:none;}</style><div id='ws-walkscore-tile'></div><script type='text/javascript' src='http://www.walkscore.com/tile/show-walkscore-tile.php'></script>
    END
  end

  def search_prices
    ['750', '1000', '1250', '1500', '1750', '2000', '2500', '3000', '4000', '5000', '6000', '7000', '8000', '9000', '10000'].map do |price|
      [number_to_currency(price), price]
    end
  end  
end
