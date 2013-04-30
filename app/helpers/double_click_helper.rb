module DoubleClickHelper
  def double_click_community_thank_you_script(community)
    double_click_floodlight_tag(community.title, 'conta168', 'Contact Info Complete')
  end

  def double_click_data_attrs(name, cat)
    {
      :'data-doubleclick-name' => URI.encode(name),
      :'data-doubleclick-cat'  => cat
    }
  end

  def double_click_email_thank_you_script(communities)
    titles = communities.map(&:title).reject(&:blank?).join(',')

    double_click_floodlight_tag(titles, 'email947', 'Email Results')
  end

  private

  def double_click_floodlight_tag(name, cat, description)
    encoded_name = URI.encode(name)

    <<-END.html_safe
      <!--
      Start of DoubleClick Floodlight Tag: Please do not remove
      Activity name of this tag: #{description}
      URL of the webpage where the tag is expected to be placed: http://www.bozzuto.com
      This tag must be placed between the <body> and </body> tags, as close as possible to the opening tag.
      Creation Date: 04/04/2013
      -->
      <script type="text/javascript">
      var axel = Math.random() + "";
      var a = axel * 10000000000000;
      document.write('<iframe src="http://4076175.fls.doubleclick.net/activityi;src=4076175;type=conve135;cat=#{cat};u1=#{encoded_name};ord=' + a + '?" width="1" height="1" frameborder="0" style="display:none"></iframe>');
      </script>
      <noscript>
      <iframe src="http://4076175.fls.doubleclick.net/activityi;src=4076175;type=conve135;cat=#{cat};u1=#{encoded_name}];ord=1?" width="1" height="1" frameborder="0" style="display:none"></iframe>
      </noscript>
      <!-- End of DoubleClick Floodlight Tag: Please do not remove -->
    END
  end
end
