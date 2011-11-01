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
      meta = object.try("#{prefix}#{field}")
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

  def facebook_like_box(facebook_url)
    content_tag :div, :class => 'facebook-like-box' do
      <<-END.html_safe
        <div id="fb-root"></div>
        <script>(function(d){
          var js, id = 'facebook-jssdk'; if (d.getElementById(id)) {return;}
          js = d.createElement('script'); js.id = id; js.async = true;
          js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
          d.getElementsByTagName('head')[0].appendChild(js);
        }(document));</script>
        <div class="fb-like-box" data-href="#{facebook_url}" data-width="230" data-show-faces="true" data-stream="true" data-header="true"></div>
      END
    end
  end


  def google_plus_one_button
    content_for(:end_of_body, '<script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script>'.html_safe)

    content_tag :div, :class => 'google-plus-one' do
      '<g:plusone size="medium"></g:plusone>'.html_safe
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
