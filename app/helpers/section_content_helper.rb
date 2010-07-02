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
        css_classes << 'current' if params[:page] == page.path

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
end
