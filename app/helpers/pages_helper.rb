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

  def pages_tree(pages, ul_wrapper = false, current_level = 0)
    formatted_pages = []

    Page.each_with_level(pages) do |page, level|
      formatted_pages << {
        :page  => page,
        :level => level
      }
    end

    pages_tree_helper(formatted_pages)
  end

  def pages_tree_helper(pages, ul_wrapper = false, current_level = 0)
    return '' if pages.empty?

    output = ''
    output << '<ul>' if ul_wrapper

    pages.each_with_index do |page_hash, i|
      page, level = page_hash[:page], page_hash[:level]

      if level == current_level
        output << '<li>'

        output << link_to(page.title, page_path(page.section, page))

        if pages[i + 1].present? && pages[i + 1][:level] > current_level
          output << pages_tree_helper(pages.drop(i + 1), true, current_level + 1)
        end

        output << '</li>'
      end
    end

    output << '</ul>' if ul_wrapper
    output.html_safe
  end
end
