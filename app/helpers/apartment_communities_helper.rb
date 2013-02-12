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

  def apartment_community_price_range(community)
    prices = [
      number_to_currency(community.cheapest_rent, :precision => 0),
      number_to_currency(community.max_rent, :precision => 0)
    ]

    prices.join(' to ').html_safe
  end

  def list_of_floor_plan_group_names_for(community)
    opts = { :two_words_connector => ' &amp; ', :last_word_connector => ', &amp; ' }

    community.floor_plan_groups.map(&:list_name).to_sentence(opts).html_safe
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

  def floor_plan_image(plan, extra = '')
    image = plan.actual_image
    thumb = plan.actual_thumb

    if image.present?
      content_tag(:div, :class => 'floor-plan-view') do
        ''.tap do |html|
          html << image_tag(thumb, :width => 160)

          html << link_to(image, :class => 'floor-plan-view-full') do
            content_tag(:span, 'View Full-Size')
          end

          html << extra
        end.html_safe
      end
    end
  end

  def website_url(url)
    url =~ /^http/ ? url : "http://#{url}"
  end

  def walkscore_map_script(community, opts = {})
    opts.reverse_merge!({
      :width  => 226,
      :height => 360
    })

    <<-END.html_safe
    <script type="text/javascript">
      var ws_wsid = '#{APP_CONFIG[:walkscore_wsid]}';
      var ws_address = '#{community.address}';
      var ws_width = '#{opts[:width]}';
      var ws_height = '#{opts[:height]}';
      var ws_layout = 'vertical';
      var ws_background_color = '#fff';
    </script>
    <style type="text/css">#ws-walkscore-tile{position:relative;text-align:left;}#ws-walkscore-tile *{float:none;}</style>
    <div id="ws-walkscore-tile"></div>
    <!-- WalkScore JS is embedded dynamically, when the WalkScore tab is clicked -->
    END
  end

  def search_prices
    ['750', '1000', '1250', '1500', '1750', '2000', '2500', '3000', '4000', '5000', '6000', '7000', '8000', '9000', '10000'].map do |price|
      [number_to_currency(price), price]
    end
  end  
end
