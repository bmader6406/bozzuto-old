module CommunitiesHelper
  def community_icons
    content_tag :ul, :class => "community-icons" do
      %w(elite smart_share smart_rent green non_smoking).inject("") do |html, flag|
        if @community.send("#{flag}?")
          html << content_tag(:li, :class => flag.gsub(/_/, '-')) do
            link_to "#" do
              content_tag(:span) { Community.human_attribute_name(flag) }
            end
          end
        end
        html
      end.html_safe
    end
  end

  def floor_plan_price(price)
    number_to_currency(price, :precision => 0)
  end

  def square_feet(plan)
    "#{plan.min_square_feet} Sq Ft"
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
end
