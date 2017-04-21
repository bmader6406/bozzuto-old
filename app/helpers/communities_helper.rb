module CommunitiesHelper
  def community_contact_callout(community, &block)
    return if @page && !@page.show_contact_callout?

    extra_content = capture(&block) if block_given?

    render 'communities/request_info', :community => community, :extra_content => extra_content
  end

  def google_conversion_code(conversion_label)
    return '' unless conversion_label.present?

    <<-END.html_safe
      <script type="text/javascript">
      /* <![CDATA[ */
      var google_conversion_id = 971751790;
      var google_conversion_language = "en";
      var google_conversion_format = "1";
      var google_conversion_color = "ffffff";
      var google_conversion_label = #{conversion_label.inspect}; var google_conversion_value = 0;
      /* ]]> */
      </script>
      <script type="text/javascript"
      src="http://www.googleadservices.com/pagead/conversion.js">
      </script>
      <noscript>
      <div style="display:inline;">
      <img height="1" width="1" style="border-style:none;" alt=""
      src="http://www.googleadservices.com/pagead/conversion/971751790/?label=#{conversion_label}&amp;guid=ON&amp;script=0"/>
      </div>
      </noscript>
    END
  end

  def bing_conversion_code(action_id)
    return'' unless action_id.present?

    <<-END.html_safe
      <script type="text/javascript"> if (!window.mstag) mstag = {loadTag : function(){},time : (new Date()).getTime()};</script> <script id="mstag_tops" type="text/javascript" src="//flex.atdmt.com/mstag/site/34ffff7a-0581-4108-b1d2-6e5b54282f02/mstag.js"></script> <script type="text/javascript"> mstag.loadTag("analytics", {dedup:"1",domainId:"1280858",type:"1",actionid:#{action_id.inspect}})</script> <noscript> <iframe src="//flex.atdmt.com/mstag/tag/34ffff7a-0581-4108-b1d2-6e5b54282f02/analytics.html?dedup=1&domainId=1280858&type=1&actionid=#{action_id}" frameborder="0" scrolling="no" width="1" height="1" style="visibility:hidden;display:none"> </iframe> </noscript>
    END
  end

  def schedule_tour_link(community, opts = {})
    return unless community.apartment_community?

    opts.reverse_merge!(:class => 'schedule-tour')

    if community.schedule_tour_url?
      opts[:'data-iframe'] = 'yes'
      opts[:'data-width']  = 800
      opts[:'data-height'] = 600
    end

    link_to 'Schedule a Tour', schedule_tour_community_path(community), opts
  end
end
