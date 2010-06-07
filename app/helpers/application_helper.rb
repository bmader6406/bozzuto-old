module ApplicationHelper
  def current_if(opts)
    if opts.is_a?(Hash)
      'current' if opts.all? { |key, val| params[key] == val }
    else
      'current' if params[:action] == opts
    end
  end

  def google_maps_javascript_tag
    <<-END.html_safe
<script src="http://maps.google.com/maps?file=api&v=2&key=#{APP_CONFIG[:google_maps_api_key]}" type="text/javascript"></script>
    END
  end
end
