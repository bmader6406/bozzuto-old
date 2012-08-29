module TrackingCodeHelper
  def value_click_tracking_code
    <<-END.html_safe
      <!-- ValueClick -->
      <img src="http://media.fastclick.net/w/tre?ad_id=27340;evt=20270;cat1=26729;cat2=26730;rand=#{Time.now.strftime('%Y%m%d%H%M%S')}#{SecureRandom.hex(2)}" width="1" height="1" border="0">
      <!-- End ValueClick -->
    END
  end
end
