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

        output << "<li #{css_class}>"

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

  def news_and_press_secondary_nav(section, news_section)
    if section_news_posts.any? || section_press_releases.any? || (news_section.present? && news_section.pages.published.any?)
      current = 'current' if params[:controller] == 'news_and_press' && params[:action] == 'index'

      content_tag :li, :class => current do
        ''.tap do |li|
          li << link_to('News & Press', news_and_press_path(section))

          subnav = []

          # pages
          if news_section.present? && news_section.pages.published.any?
            subnav << pages_tree(news_section.pages.published).html_safe
          end

          # news
          if section_news_posts.any?
            current = params[:controller] == 'news_posts' ? 'current' : nil
            subnav << content_tag(:li, :class => current) do
              link_to('News', news_posts_path(section))
            end
          end

          # awards
          if section_awards.any?
            current = params[:controller] == 'awards' ? 'current' : nil
            subnav << content_tag(:li, :class => current) do
              link_to 'Awards', awards_path(section)
            end
          end

          # press releases
          if section_press_releases.any?
            current = params[:controller] == 'press_releases' ? 'current' : nil
            subnav << content_tag(:li, :class => current) do
              link_to('Press Releases', press_releases_path(section), :class => current)
            end
          end

          if subnav.any?
            li << content_tag(:ul) { subnav.join.html_safe }
          end
        #:nocov:
        end.html_safe
        #:nocov:
      end
    end
  end
end
