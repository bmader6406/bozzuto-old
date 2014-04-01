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

  def apartment_community_price_range(community)
    prices = [
      community.min_rent,
      community.max_rent
    ]

    prices = prices.reject(&:blank?).reject(&:zero?).map { |p| dollars(p) }

    if prices.length == 2
      prices.join(' to ').html_safe
    else
      ''
    end
  end

  def list_of_floor_plan_group_names_for(community)
    opts = { :two_words_connector => ' &amp; ', :last_word_connector => ', &amp; ' }

    community.floor_plan_groups.map(&:list_name).to_sentence(opts).html_safe
  end

  def square_feet(value)
    if value.present? 
      "#{value} Sq Ft"
    else
      ''
    end
  end

  def floor_plan_image(plan, extra = '')
    image = plan.actual_image
    thumb = plan.actual_thumb

    if image.present?
      content_tag(:div, :class => 'floor-plan-view') do
        content = ''.tap do |html|
          html << image_tag(thumb, :width => 160)

          html << link_to(image, :class => 'floor-plan-view-full') do
            content_tag(:span, 'View Full-Size')
          end

          html << extra
        end

        content.html_safe
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
      [dollars_and_cents(price), price]
    end
  end

  def availability_link(community, opts = {})
    text = community.managed_by_rent_cafe? ? 'Apply Now' : 'Availability'
    url  = community.availability_url.presence || apartment_community_contact_path(community)

    link_to(text, url, opts={})
  end

  def reserve_link(plan, opts = {})
    text = plan.managed_by_rent_cafe? ? 'Apply Now' : 'Reserve'
    url  = plan.availability_url

    link_to(text, url, opts)
  end
end
