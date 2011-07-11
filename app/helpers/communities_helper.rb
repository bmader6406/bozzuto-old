module CommunitiesHelper
  def community_contact_callout(community)
    render 'communities/request_info', :community => community
  end

  def mediamind_activity_code(activity_id)
    return '' unless activity_id.present?

    <<-END.html_safe
      <script type="text/javascript">
      var ebRand = Math.random() + '';
      ebRand = ebRand * 1000000;
      //<![CDATA[
      document.write('<scr'+'ipt src="HTTP://bs.serving-sys.com/BurstingPipe/ActivityServer.bs?cn=as&amp;ActivityID=#{activity_id}&amp;rnd=' + ebRand + '"></scr' + 'ipt>');
      //]]>
      </script>
      <noscript>
      <img width="1" height="1" style="border:0" src="HTTP://bs.serving-sys.com/BurstingPipe/ActivityServer.bs?cn=as&amp;ActivityID=#{activity_id}&amp;ns=1"/>
      </noscript>
    END
  end
end
