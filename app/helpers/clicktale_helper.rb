module ClicktaleHelper
  def clicktale_top
    <<-END.html_safe
<!-- ClickTale Top part -->
<script type="text/javascript">
var WRInitTime=(new Date()).getTime();
</script>
<!-- ClickTale end of Top part -->
    END
  end

  def clicktale_bottom
    <<-END.html_safe
<!-- ClickTale Bottom part -->
<div id="ClickTaleDiv" style="display: none;"></div>
<script type='text/javascript'>
document.write(unescape("%3Cscript%20src='"+
 (document.location.protocol=='https:'?
  'https://clicktale.pantherssl.com/':
  'http://s.clicktale.net/')+
 "WRc9.js'%20type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
var ClickTaleSSL=1;
if(typeof ClickTale=='function') ClickTale(50512,1,"www");
</script>
<!-- ClickTale end of Bottom part -->
    END
  end
end
