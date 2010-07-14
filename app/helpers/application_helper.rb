module ApplicationHelper
  def home?
    params[:controller] == 'home_pages'
  end

  def render_meta(item)
    render :partial => 'layouts/seo_meta', :locals => { :item => item }
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
<script src="http://maps.google.com/maps?file=api&v=2&key=#{APP_CONFIG[:google_maps_api_key]}" type="text/javascript"></script>
    END
  end

  def share_this_link
    content_tag :p, :class => 'sharethis' do
      '<script type="text/javascript" src="http://w.sharethis.com/button/sharethis.js#publisher=1348f130-9dcb-4c1d-8a9d-bca69699b922&amp;type=website&amp;post_services=email%2Cfacebook%2Ctwitter%2Cgbuzz%2Cmyspace%2Cdigg%2Csms%2Cwindows_live%2Cdelicious%2Cstumbleupon%2Creddit%2Cgoogle_bmarks%2Clinkedin%2Cbebo%2Cybuzz%2Cblogger%2Cyahoo_bmarks%2Cmixx%2Ctechnorati%2Cfriendfeed%2Cpropeller%2Cwordpress%2Cnewsvine"></script>'.html_safe
    end
  end

  def facebook_like_link
    content_tag :div, :class => 'facebook-like' do
      '<iframe src="http://www.facebook.com/plugins/like.php?href=http%3A%2F%2Flocalhost%3A3000%2Fmockup%2Ffeatures&amp;layout=standard&amp;show_faces=false&amp;width=230&amp;action=like&amp;font=arial&amp;colorscheme=light&amp;height=35" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:230px; height:35px;" allowTransparency="true"></iframe>'.html_safe
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
end
