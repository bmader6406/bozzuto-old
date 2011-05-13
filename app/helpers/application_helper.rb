module ApplicationHelper
  include Twitter::Autolink

  def black_hole; end

  def twitter_url(username)
    "http://twitter.com/#{username}".html_safe
  end

  def home?
    params[:controller] == 'home_pages'
  end

  def render_meta(object, prefix = nil)
    prefix = "#{prefix}_" if prefix.present?

    %w( meta_title meta_description meta_keywords ).each do |field|
      meta = object.send("#{prefix}#{field}")
      content_for(field.to_sym, meta) if meta.present?
    end
  end

  def current_if(opts)
    if opts.is_a?(Hash)
      'current' if opts.all? { |key, val| params[key] == val }
    else
      'current' if params[:action] == opts
    end
  end

  def month_and_day(date)
    str = ''
    str << content_tag(:span, :class => 'month') do
      date.strftime('%m') + '.'
    end
    str << content_tag(:span, :class => 'day') do
      date.strftime('%d') + '.'
    end
    str.html_safe
  end

  def google_maps_javascript_tag
    <<-END.html_safe
    <script src="http://maps.google.com/maps?file=api&v=2&key= #{APP_CONFIG[:google_maps_api_key]} " type="text/javascript"></script>
    END
  end

  def share_this_link
    content_tag :p, :class => 'sharethis' do
      '<script type="text/javascript" src="http://w.sharethis.com/button/sharethis.js#publisher=1348f130-9dcb-4c1d-8a9d-bca69699b922&amp;type=website&amp;post_services=email%2Cfacebook%2Ctwitter%2Cgbuzz%2Cmyspace%2Cdigg%2Csms%2Cwindows_live%2Cdelicious%2Cstumbleupon%2Creddit%2Cgoogle_bmarks%2Clinkedin%2Cbebo%2Cybuzz%2Cblogger%2Cyahoo_bmarks%2Cmixx%2Ctechnorati%2Cfriendfeed%2Cpropeller%2Cwordpress%2Cnewsvine"></script>'.html_safe
    end
  end

  def facebook_like_link(url)
    content_tag :div, :class => 'facebook-like' do
      <<-END.html_safe
      <iframe src="http://www.facebook.com/plugins/like.php?href=#{CGI::escape(url)}&amp;layout=standard&amp;show_faces=false&amp;width=230&amp;action=like&amp;font=arial&amp;colorscheme=light&amp;height=35" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:230px; height:35px;" allowTransparency="true"></iframe>
      END
    end
  end

  def bedrooms(record)
    pluralize(record.bedrooms, 'Bedroom')
  end

  def bathrooms(record)
    bathrooms = if record.bathrooms.frac.to_f == 0.0
      record.bathrooms.to_i
    else
      record.bathrooms.to_f
    end
    pluralize(bathrooms, 'Bathroom')
  end

  def sanitize_phone_number(number)
    (number || '').gsub(/\D/, '')
  end

  def format_phone_number(number)
    pn = sanitize_phone_number(number)
    pn = '1' << pn if pn.length == 10

    if pn.length == 11
      '(%s) %s-%s' % [pn[1..3], pn[4..6], pn[7..10]]
    else
      number
    end
  end

  def phone_number_uri(number)
    pn = sanitize_phone_number(number)

    if pn.length == 10
      "tel:+1#{pn}"
    else
      "tel:+#{pn}"
    end
  end

  def link_to_phone_number(*args, &block)
    if block_given?
      number       = args.first
      html_options = args.second || {}

      link_to(phone_number_uri(number), html_options, &block)
    else
      name         = args.first
      number       = args.second || {}
      html_options = args.third || {}

      link_to(name, phone_number_uri(number), html_options)
    end
  end

  def dnr_phone_number(community, opts = {})
    opts.reverse_merge!(:width => 150, :height => 17)

    return '' unless community.phone_number.present?

    number = sanitize_phone_number(community.phone_number)

    account = if community.is_a?(ApartmentCommunity)
      APP_CONFIG[:callsource]['apartment']
    elsif community.is_a?(HomeCommunity)
      APP_CONFIG[:callsource]['home']
    end

    dnr = community.dnr_configuration

    args = [
      number,
      'xxx.xxx.xxxx',
      account,
      dnr.try(:customer_code) || 'undefined',
      dnr.try(:campaign) || 'undefined',
      dnr.try(:ad_source) || 'undefined',
    ].map { |arg| "'#{arg}'" }

    <<-SCRIPT.html_safe
      <span class="phone-number">
        #{number}
        <script type="text/javascript-dnr" -data-width="#{opts[:width]}" -data-height="#{opts[:height]}">
          replaceNumber(#{args.join(', ')});
        </script>
      </span>
    SCRIPT
  end

  def snippet(name)
    snippet = Snippet.find_by_name(name)
    if snippet.present?
      snippet.body.html_safe
    else
      content_tag :p do
        raw(%Q{This area should be filled in by snippet "#{name}," which does not exist.
            #{link_to("Click here to create the snippet.", {:controller => 'admin/snippets',
                                                            :action => 'new',
                                                            "name" => name})}})
      end
    end
  end

  def state_apartment_search_path(state)
    apartment_communities_path("search[in_state]" => state.id)
  end

  def city_apartment_search_path(city)
    apartment_communities_path("search[city_id]" => city.id)
  end

  def county_apartment_search_path(county)
    apartment_communities_path("search[county_id]" => county.id)
  end

  def state_home_search_path(state)
    home_communities_path("search[in_state]" => state.id)
  end

  def city_home_search_path(city)
    home_communities_path("search[city_id]" => city.id)
  end

  def county_home_search_path(county)
    home_communities_path("search[county_id]" => county.id)
  end

  def community_url(community)
    case community
    when ApartmentCommunity then
      apartment_community_url(community)
    when HomeCommunity then
      home_community_url(community)
    end
  end
end
