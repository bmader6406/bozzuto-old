module SectionContentHelper
  def breadcrumb_item(item)
    content_for :breadcrumb do
      content_tag(:li) { item }.html_safe
    end
  end

  def breadcrumb_title(title)
    content_for(:breadcrumb_title) { title }
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
        css_classes = []
        css_classes << 'first' if level == 0 and i == 0
        css_classes << 'current' if current_page_path == page.path

        css_class = %{class="#{css_classes.join(' ')}"} if css_classes.any?

        output << ''.tap do |li|
          url = page.section.service? ? services_page_url(page.section, page) : page_url(page.section, page)
          li << "<li #{css_class}>"
          li << link_to(page.title, url)

          children = pages.select { |p| p[:page].parent_id == page.id }

          if children.any?
            li << pages_tree_helper(children, true, level + 1)
          end

          li << '</li>'
        end
      end
    end

    output << '</ul>' if ul_wrapper
    output.html_safe
  end

  def news_and_press_secondary_nav(section, news_section)
    if section_news_posts.any? || section_press_releases.any? || (news_section.present? && news_section.pages.published.any?)
      current = 'current' if params[:controller] == 'news_and_press' && params[:action] == 'index'

      content_tag :li, :class => current do
        ''.tap do |li|
          url = section.service? ? services_news_and_press_url(section) : news_and_press_url(section)
          li << link_to('News & Press', url)

          subnav = []

          # news
          if section_news_posts.any?
            current = params[:controller] == 'news_posts' ? 'current' : nil
            subnav << content_tag(:li, :class => current) do
              url = section.service? ? services_news_posts_path(section) : news_posts_path(section)
              link_to 'News', url
            end
          end

          # awards
          # :nocov:
          if section_awards.any?
            current = params[:controller] == 'awards' ? 'current' : nil
            subnav << content_tag(:li, :class => current) do
              url = section.service? ? services_awards_path(section) : awards_path(section)
              link_to 'Awards', url
            end
          end
          # :nocov:

          # press releases
          if section_press_releases.any?
            current = params[:controller] == 'press_releases' ? 'current' : nil
            subnav << content_tag(:li, :class => current) do
              url = section.service? ? services_press_releases_path(section) : press_releases_path(section)
              link_to 'Press Releases', url, :class => current
            end
          end

          # rankings
          if @section == Section.about
            current = params[:controller] == 'rankings' ? 'current' : nil
            subnav << content_tag(:li, :class => current) do
              link_to 'Rankings', rankings_path, :class => current
            end
          end

          if subnav.any?
            li << content_tag(:ul) { subnav.join.html_safe }
          end
        end.html_safe
      end
    end
  end
end
