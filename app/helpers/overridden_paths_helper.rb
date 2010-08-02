module OverriddenPathsHelper
  def page_path(section, page = nil)
    if section.service?
      service_section_page_path(section, page.try(:path))
    elsif section == Section.news_and_press
      news_and_press_page_path(page.try(:path))
    else
      section_page_path(section, page.try(:path))
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

  def project_path(section, project)
    if section.service?
      service_section_project_path(section, project)
    else
      section_project_path(section, project)
    end
  end

  def testimonials_path(section)
    if section.service?
      service_section_testimonials_path(section)
    else
      section_testimonials_path(section)
    end
  end

  def property_path(property)
    if property.is_a?(Project)
      project_path(property.section, property)
    else
      property
    end
  end

  def send_to_friend_path(community)
    if community.is_a?(ApartmentCommunity)
      send_to_friend_apartment_community_path(community)
    else
      send_to_friend_home_community_path(community)
    end
  end
end
