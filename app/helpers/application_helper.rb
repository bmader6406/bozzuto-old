module ApplicationHelper
  def current_if(opts)
    if opts.is_a?(Hash)
      'current' if opts.all? { |key, val| params[key] == val }
    else
      'current' if params[:action] == opts
    end
  end

  def month_and_day(date)
    returning('') do |str|
      str << content_tag(:span, :class => 'month') do
        date.strftime('%m') + '.'
      end
      str << content_tag(:span, :class => 'day') do
        date.strftime('%d') + '.'
      end
    end.html_safe
  end

  def google_maps_javascript_tag
    <<-END.html_safe
<script src="http://maps.google.com/maps?file=api&v=2&key=#{APP_CONFIG[:google_maps_api_key]}" type="text/javascript"></script>
    END
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
      output << link_to(page.title, section_page_path(page.section, page.path))

      level = page_level
    end

    # walked off the end with open uls
    output += '</li></ul>' * level unless level.zero?
    output.html_safe
  end
end
