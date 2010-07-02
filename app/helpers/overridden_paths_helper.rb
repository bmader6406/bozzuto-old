module OverriddenPathsHelper
  def page_path(section, page = nil)
    if section.service?
      service_section_page_path(section, page.try(:path))
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
end
