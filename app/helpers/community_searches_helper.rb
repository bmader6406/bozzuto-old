module CommunitySearchesHelper
  def render_search_results(results)
    ''.tap do |output|
      results.each do |result|
        partial = if result.is_a? ApartmentCommunity
          "apartment_communities/listing"
        else
          "home_communities/listing"
        end

        output << render(:partial => partial, :locals => { :community => result })
      end
    #:nocov:
    end.html_safe
    #:nocov:
  end
end
