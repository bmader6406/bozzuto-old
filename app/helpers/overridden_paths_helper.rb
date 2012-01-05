module OverriddenPathsHelper
  def page_path(section, page = nil)
    path = page.is_a?(String) ? page : page.try(:path)

    if section.service?
      service_section_page_path(section, page)
    elsif section == Section.news_and_press
      news_and_press_page_path(page)
    else
      section_page_path(section, page)
    end
  end

  def news_posts_path(section)
    if section.service?
      service_section_news_posts_path(section)
    else
      section_news_posts_path(section)
    end
  end

  def news_post_path(section, post)
    if section.service?
      service_section_news_post_path(section, post)
    else
      section_news_post_path(section, post)
    end
  end

  def press_releases_path(section)
    if section.service?
      service_section_press_releases_path(section)
    else
      section_press_releases_path(section)
    end
  end

  def press_release_path(section, press_release)
    if section.service?
      service_section_press_release_path(section, press_release)
    else
      section_press_release_path(section, press_release)
    end
  end

  def news_and_press_path(section)
    if section.service?
      service_section_news_and_press_path(section)
    else
      section_news_and_press_path(section)
    end
  end

  def awards_path(section)
    if section.service?
      service_section_awards_path(section)
    else
      section_awards_path(section)
    end
  end

  def award_path(section, award)
    if section.service?
      service_section_award_path(section, award)
    else
      section_award_path(section, award)
    end
  end

  def projects_path(section)
    if section.service?
      service_section_projects_path(section)
    else
      section_projects_path(section)
    end
  end

  def project_path(section, project, options = nil)
    if section.service?
      service_section_project_path(section, project, options)
    else
      section_project_path(section, project, options)
    end
  end

  def testimonials_path(section)
    if section.service?
      service_section_testimonials_path(section)
    else
      section_testimonials_path(section)
    end
  end

  def property_path(property, options = nil)
    case property
    when Project
      project_path(property.section, property, options)
    when ApartmentCommunity
      apartment_community_path(property, options)
    when HomeCommunity
      home_community_path(property, options)
    end
  end

  %w(url path).each do |type|
    define_method "contact_community_#{type}" do |property|
      if property.is_a?(ApartmentCommunity)
        send("apartment_community_lead2_lease_submissions_#{type}", property)
      else
        send("home_community_lasso_submissions_#{type}", property)
      end
    end
  end

  def send_to_friend_path(community)
    if community.is_a?(ApartmentCommunity)
      apartment_community_send_to_friend_submissions_path(community)
    else
      home_community_send_to_friend_submissions_path(community)
    end
  end

  def section_contact_path(section)
    if section.contact_topic.present?
      contact_path(:topic => @section.contact_topic)
    else
      contact_path
    end
  end

  def send_me_updates_path(community)
    if community.is_a?(ApartmentCommunity)
      apartment_community_sms_message_path(community)
    else
      home_community_sms_message_path(community)
    end
  end
end
