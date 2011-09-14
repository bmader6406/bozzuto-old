module SearchesHelper
  #:nocov:
  def paginate_search(search)
    count         = 10
    current_start = search.start.to_i
    total_results = search.totalresults.to_i
    total_pages   = (total_results.to_f / count).ceil

    # cap total number of pages to 100
    if (total_pages - 1) * count > 1000
      total_pages = 100
    end

    if current_start > 0 || total_results > count
      links = []

      1.upto(total_pages).each do |i|
        start = (i - 1) * count

        if start == current_start
          links << content_tag(:span, i, :class => 'current')
        else
          links << link_to(i, search_path(:q => @query, :start => start))
        end
      end

      links.join(' ').html_safe
    end
  end
  #:nocov:
end
