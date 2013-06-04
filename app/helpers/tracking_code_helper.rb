module TrackingCodeHelper
  def value_click_tracking_code
    <<-END.html_safe
      <!-- ValueClick -->
      <img src="http://media.fastclick.net/w/tre?ad_id=27340;evt=20270;cat1=26729;cat2=26730;rand=#{Time.now.strftime('%Y%m%d%H%M%S')}#{random_number_string(4)}" width="1" height="1" border="0">
      <!-- End ValueClick -->
    END
  end

  def rtrk_code(community)
    if community.show_rtrk_code?
      <<-END.html_safe
        <script type="text/javascript" >
          var reachlocalTRKDOM="rtsys.rtrk.com ";
          (function() {
          var rlocal_load = document.createElement("script");
          rlocal_load.type = "text/javascript";
          rlocal_load.src = document.location.protocol+"//rtsys.rtrk.com/campaign_images/d1035/1035708/rltrk1.js ";
          (document.getElementsByTagName("head")[0] || document.getElementsByTagName("body")[0]).appendChild (rlocal_load);
          })();
        </script>
      END
    end
  end

  def value_click_apartment_thank_you_code
    '<img src="http://media.fastclick.net/w/roitrack.cgi?aid=1000044195" width=1 height=1 border=0>'.html_safe
  end

  def facebook_apartment_thank_you_code
    <<-HTML.html_safe
      <script type="text/javascript">
        var fb_param = {};
        fb_param.pixel_id = '6007551186980';
        fb_param.value = '0.00';
        (function(){
          var fpw = document.createElement('script');
          fpw.async = true;
          fpw.src = '//connect.facebook.net/en_US/fp.js';
          var ref = document.getElementsByTagName('script')[0];
          ref.parentNode.insertBefore(fpw, ref);
        })();
      </script>
      <noscript>
        <img height="1" width="1" alt="" style="display:none" src="https://www.facebook.com/offsite_event.php?id=6007551186980&amp;value=0" />
      </noscript>
    HTML
  end

  private

  def random_number_string(length)
    "%0#{length}d" % (Kernel.rand * (10 ^ length))
  end
end
