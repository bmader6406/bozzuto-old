module MediaplexHelper
  def timestamp
    Time.new.to_i.to_s
  end

  def send_to_phone_mediaplex_code(community)
    mpuid = [timestamp, community.id].reject(&:blank?).join(';')

    if community.is_a? HomeCommunity
      <<-END.html_safe
        <iframe src="http://img-cdn.mediaplex.com/0/16797/universal.html?page_name=bozzuto_homes_send_to_phone&Bozzuto_Homes_Send_To_Phone=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
      END
    elsif community.is_a? ApartmentCommunity
      <<-END.html_safe
        <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=apartments_send_to_phone&Apartments_Send_to_Phone=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
      END
    end
  end

  def send_to_friend_mediaplex_code(community, email)
    mpuid = [timestamp, email, community.id].reject(&:blank?).join(';')

    if email.present?
      if community.is_a? HomeCommunity
        <<-END.html_safe
          <iframe src="http://img-cdn.mediaplex.com/0/16797/universal.html?page_name=bozzuto_homes_send_to_friend&Bozzuto_Homes_Send_To_Friend=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
        END
      elsif community.is_a? ApartmentCommunity
        <<-END.html_safe
          <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=apartments_send_to_friend&Apartments_Send_to_Friend=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
        END
      end
    end
  end

  def send_me_updates_mediaplex_code(email)
    mpuid = [timestamp, email].reject(&:blank?).join(';')

    <<-END.html_safe
      <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=apartments_send_me_updates&Apartments_Send_Me_Updates=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
    END
  end

  def home_contact_form_mediaplex_code(community, email)
    mpuid = [timestamp, email, community.id].reject(&:blank?).join(';')

    <<-END.html_safe
      <iframe src="http://img-cdn.mediaplex.com/0/16797/universal.html?page_name=bozzuto_homes_lead&Bozzuto_Homes_Lead=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
    END
  end

  def bozzuto_buzz_mediaplex_code(email)
    mpuid = [timestamp, email].reject(&:blank?).join(';')

    <<-END.html_safe
      <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=bozzutobuzz&BozzutoBuzz=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
    END
  end

  def lead_2_lease_mediaplex_code(community, email)
    mpuid = [email, community.lead_2_lease_id].reject(&:blank?).join(';')

    <<-END.html_safe
      <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=bozzuto.com_apartments_lead&Bozzuto.com_Apartments_Lead=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
    END
  end

  def contact_mediaplex_code(email)
    mpuid = [timestamp, email].reject(&:blank?).join(';')

    <<-END.html_safe
      <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=contact_us&Contact_Us=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
    END
  end

  def apartment_contact_mediaplex_code(community, email)
    if community && community.mediaplex_tag.present?
      page_name = community.mediaplex_tag.page_name
      roi_name  = community.mediaplex_tag.roi_name
      mpuid     = [timestamp, email].reject(&:blank?).join(';')

      <<-END.html_safe
        <iframe src="http://img-cdn.mediaplex.com/0/16798/universal.html?page_name=#{page_name}&#{roi_name}=1&mpuid=#{mpuid}" HEIGHT=1 WIDTH=1 FRAMEBORDER=0></iframe>
      END
    end
  end
end
