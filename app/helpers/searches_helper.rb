module SearchesHelper
  def paginate_search(search)
    totalhits = search.totalhits.to_i
    count = 10 # search.count.to_i
    current_start = search.start.to_i

    if current_start > 0 || totalhits > count
      links = []
      1.upto((totalhits.to_f / count).ceil).each do |i|
        start = (i - 1) * count
        if start == current_start
          links << i
        else
          links << link_to(i, search_path(:q => @query, :start => start))
        end
      end

      links.join("&nbsp;").html_safe
    end
  end
end
