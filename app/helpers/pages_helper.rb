module PagesHelper
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

  def testimonials_path(section)
    if section.service?
      service_section_testimonials_path(section)
    else
      section_testimonials_path(section)
    end
  end

  def pages_tree(pages)
    level    = 0
    output   = ''

    Page.each_with_level(pages) do |page, page_level|
      # open new level
      if page_level > level
        output << '<ul>'

      # close level
      elsif page_level < level
        output << '</li></ul>'

      # same level, close li
      else
        output << '</li>'
      end

      output << '<li>'
      output << link_to(page.title, page_path(page.section, page))

      level = page_level
    end

    # walked off the end with open uls
    output += '</li></ul>' * level unless level.zero?
    output.html_safe
  end
end
