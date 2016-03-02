module ApplicationHelper
  #include Twitter::Autolink

  def black_hole; end

  #:nocov:
  def if_present?(thing, &block)
    thing.present? ? capture(thing, &block) : ''
  end

  def if_nonzero?(thing, &block)
    thing.to_i.nonzero? ? capture(thing, &block) : ''
  end
  #:nocov:

  def twitter_url(username)
    "http://twitter.com/#{username}".html_safe
  end

  def home?
    params[:controller] == 'home_pages'
  end

  def render_meta(object, prefix = nil)
    prefix = "#{prefix}_" if prefix.present?

    if object.respond_to?(:seo_metadata)
      object = object.seo_metadata
    end

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
    js_params = {
      :sensor => false,
      :key    => APP_CONFIG[:google_maps_api_key]
    }.reject { |_, v| v.nil? }

    <<-END.html_safe
      <script type="text/javascript" src="//maps.googleapis.com/maps/api/js?#{js_params.to_param}"></script>
    END
  end

  def jmapping(thing)
    %{data-jmapping='#{thing.as_jmapping.to_json}'}.html_safe
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

  def ga_escape(str)
    str.gsub(/[,']/, '')
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
    snippet = Snippet.find_by(name: name)
    if snippet.present?
      snippet.body.html_safe
    else
      link = link_to "Click here to create the snippet.", [:new, :admin, :snippet, name: name]

      content_tag :p do
        raw("This area should be filled in by snippet \"#{name},\" which does not exist. #{link}")
      end
    end
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
