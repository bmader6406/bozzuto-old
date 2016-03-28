module LassoHelper

  def lasso_tracking_js(community)
    return unless community.respond_to?(:lasso_account) && community.lasso_account.present?

    if community.lasso_account.analytics_id.present?
      analytics_id = community.lasso_account.analytics_id

      <<-END.html_safe
        <script type="text/javascript">
        var _ldstJsHost = (("https:" == document.location.protocol) ? "https://" : "http://");
        _ldstJsHost += "www.mylasso.com";
        document.write(unescape("%3Cscript src='" + _ldstJsHost + "/analytics.js' type='text/javascript'%3E%3C/script%3E"));
        </script>

        <script type="text/javascript">
        <!--
        try {
        var tracker = new LassoAnalytics(#{analytics_id.inspect});
        tracker.setTrackingDomain(_ldstJsHost);
        tracker.init();
        tracker.track();
        } catch(error) {}
        -->
        </script>
      END
    end
  end

  def lasso_hidden_fields(community)
    if community.respond_to?(:lasso_account) && community.lasso_account.present?
      lasso = community.lasso_account

      fields = ''

      fields << hidden_field_tag('LassoUID', lasso.uid)
      fields << hidden_field_tag('ClientID', lasso.client_id)
      fields << hidden_field_tag('ProjectID', lasso.project_id)
      fields << hidden_field_tag('SignupThankyouLink', thank_you_home_community_contact_url(community))

      if lasso.analytics_id.present?
        fields << hidden_field_tag('domainAccountId', lasso.analytics_id)
        fields << hidden_field_tag('guid')
      end

      fields.html_safe
    end
  end

  def secondary_lead_source(community)
    if community.secondary_lead_source_id.present?
      hidden_field_tag(community.secondary_lead_source_id, 'www.bozzuto.com').html_safe
    end
  end

  def lasso_contact_js(community)
    return unless community.respond_to?(:lasso_account) && community.lasso_account.present?

    if community.lasso_account.analytics_id.present?
      <<-END.html_safe
        <script type="text/javascript">
        (function(i) {var u =navigator.userAgent;
        var e=/*@cc_on!@*/false; var st = setTimeout;if(/webkit/i.test(u)){st(function(){var dr=document.readyState;
        if(dr=="loaded"||dr=="complete"){i()}else{st(arguments.callee,10);}},10);}
        else if((/mozilla/i.test(u)&&!/(compati)/.test(u)) || (/opera/i.test(u))){
        document.addEventListener("DOMContentLoaded",i,false); } else if(e){     (
        function(){var t=document.createElement("doc:rdy");try{t.doScroll("left");
        i();t=null;}catch(e){st(arguments.callee,0);}})();}else{window.onload=i;}})
        (function() {document.getElementById('lasso-form').guid.value = tracker.readCookie("ut");});
        </script>
      END
    end
  end
end
