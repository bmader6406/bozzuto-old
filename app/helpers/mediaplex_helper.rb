module MediaplexHelper
  def timestamp
    Time.new.to_i.to_s
  end

  def send_to_friend_mediaplex_code(community, email)
    mpuid = mpuid_with([timestamp, email, community.id])

    if email.present?
      if community.home_community?
        <<-END.html_safe
          <iframe src="http://img-cdn.mediaplex.com/0/16797/universal.html?page_name=bozzuto_homes_send_to_friend&Bozzuto_Homes_Send_To_Friend=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
        END
      elsif community.apartment_community?
        <<-END.html_safe
          <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=apartments_send_to_friend&Apartments_Send_to_Friend=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
        END
      end
    end
  end

  def send_me_updates_mediaplex_code(email)
    mpuid = mpuid_with([timestamp, email])

    <<-END.html_safe
      <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=apartments_send_me_updates&Apartments_Send_Me_Updates=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
    END
  end

  def home_contact_form_mediaplex_code(community, email)
    mpuid = mpuid_with([timestamp, email, community.id])

    <<-END.html_safe
      <iframe src="http://img-cdn.mediaplex.com/0/16797/universal.html?page_name=bozzuto_homes_lead&Bozzuto_Homes_Lead=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
    END
  end

  def bozzuto_buzz_mediaplex_code(email)
    mpuid = mpuid_with([timestamp, email])

    <<-END.html_safe
      <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=bozzutobuzz&BozzutoBuzz=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
    END
  end

  def lead_2_lease_mediaplex_code(community, email = nil)
    mpuid = mpuid_with([email, community.lead_2_lease_id])

    <<-END.html_safe
      <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=bozzuto.com_apartments_lead&Bozzuto.com_Apartments_Lead=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
    END
  end

  def contact_mediaplex_code(email)
    mpuid = mpuid_with([timestamp, email])

    <<-END.html_safe
      <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=contact_us&Contact_Us=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
    END
  end

  def apartment_contact_mediaplex_code(community, email = nil)
    if community && community.mediaplex_tag.present?
      page_name = community.mediaplex_tag.page_name
      roi_name  = community.mediaplex_tag.roi_name
      mpuid     = mpuid_with([timestamp, email])

      <<-END.html_safe
        <!-- Begin Mediaplex Code -->
        <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=#{page_name}&#{roi_name}=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
        <!-- End Mediaplex Code -->
      END
    end
  end

  def master_conversion_mediaplex_code(email = nil)
    mpuid = mpuid_with([timestamp, email])

    <<-END.html_safe
      <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=master_conversion_tag&Leads=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
    END
  end

  def community_homepage_mediaplex_code(community)
    mpuid = mpuid_with([timestamp, community.id])

    if uptown_home_community?(community)
      <<-END.html_safe
        <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=uptownhomepage&UptownHomepage=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
      END
    end
  end

  def community_features_mediaplex_code(community)
    mpuid = mpuid_with([timestamp, community.id])

    if uptown_home_community?(community)
      <<-END.html_safe
        <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=uptownfeatures&UptownFeatures=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
      END
    end
  end

  def community_media_mediaplex_code(community)
    mpuid = mpuid_with([timestamp, community.id])

    if uptown_home_community?(community)
      <<-END.html_safe
        <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=uptownphotos&UptownPhotos=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
      END
    end
  end

  def community_homes_mediaplex_code(community)
    mpuid = mpuid_with([timestamp, community.id])

    if uptown_home_community?(community)
      <<-END.html_safe
        <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=uptownhome&UptownHomes=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
      END
    end
  end

  def community_neighborhood_mediaplex_code(community)
    mpuid = mpuid_with([timestamp, community.id])

    if uptown_home_community?(community)
      <<-END.html_safe
        <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=uptownneighborhood&UptownNeighborhood=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
      END
    end
  end

  def community_contact_mediaplex_code(community)
    mpuid = mpuid_with([timestamp, community.id])

    if uptown_home_community?(community)
      <<-END.html_safe
        <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=uptowncontact&UptownContact=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
      END
    end
  end

  def community_contact_thank_you_mediaplex_code(community, email)
    mpuid = mpuid_with([timestamp, email, community.id])

    if email.present?
      if uptown_home_community?(community)
        <<-END.html_safe
          <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=uptownthankyou&UptownThankYou=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
        END
      end
    end
  end

  def render_mediaplex_code(code)
    content_for(:mediaplex_code, code)
  end

  def mediaplex_rocket_fuel_tracking_pixel
    <<-END.html_safe
      <!-- Code for Action: Bozzuto Tracking Pixel 5.21.15 -->
      <!-- Begin Rocket Fuel Conversion Action Tracking Code Version 9 -->
      <script type='text/javascript'>
      (function() {
              var w = window, d = document;
              var s = d.createElement('script');
              s.setAttribute('async', 'true');
              s.setAttribute('type', 'text/javascript');
              s.setAttribute('src', '//c1.rfihub.net/js/tc.min.js');
              var f = d.getElementsByTagName('script')[0];
              f.parentNode.insertBefore(s, f);
              if (typeof w['_rfi'] !== 'function') {
                      w['_rfi']=function() {
                              w['_rfi'].commands = w['_rfi'].commands || [];
                              w['_rfi'].commands.push(arguments);
                      };
              }
              _rfi('setArgs', 'ver', '9');
              _rfi('setArgs', 'rb', '19725');
              _rfi('setArgs', 'ca', '20673497');
              _rfi('track');
      })();
      </script>
      <noscript>
        <iframe src='//20673497p.rfihub.com/ca.html?rb=19725&ca=20673497&ra=<mpuid/>' style='display:none;padding:0;margin:0' width='0' height='0'>
      </iframe>
      </noscript>
      <!-- End Rocket Fuel Conversion Action Tracking Code Version 9 -->
    END
  end

  def mediaplex_rocket_fuel_conversion_pixel
    <<-END.html_safe
        <!-- Code for Action: Bozzuto Conversion Pixel 5.21.15 -->
        <!-- Begin Rocket Fuel Conversion Action Tracking Code Version 9 -->
        <script type='text/javascript'>
        (function() {
                var w = window, d = document;
                var s = d.createElement('script');
                s.setAttribute('async', 'true');
                s.setAttribute('type', 'text/javascript');
                s.setAttribute('src', '//c1.rfihub.net/js/tc.min.js');
                var f = d.getElementsByTagName('script')[0];
                f.parentNode.insertBefore(s, f);
                if (typeof w['_rfi'] !== 'function') {
                        w['_rfi']=function() {
                                w['_rfi'].commands = w['_rfi'].commands || [];
                                w['_rfi'].commands.push(arguments);
                        };
                }
                _rfi('setArgs', 'ver', '9');
                _rfi('setArgs', 'rb', '19725');
                _rfi('setArgs', 'ca', '20673499');
                _rfi('track');
        })();
        </script>
        <noscript>
          <iframe src='//20673499p.rfihub.com/ca.html?rb=19725&ca=20673499&ra=<mpuid/>' style='display:none;padding:0;margin:0' width='0' height='0'>
        </iframe>
        </noscript>
        <!-- End Rocket Fuel Conversion Action Tracking Code Version 9 -->
    END
  end

  private

  def mpuid_with(parts)
    parts.reject(&:blank?).join(';')
  end

  def uptown_home_community?(community)
    community.home_community? && community.id == 273
  end
end
