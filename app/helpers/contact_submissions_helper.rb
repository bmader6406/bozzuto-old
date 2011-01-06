module ContactSubmissionsHelper
  def corporate_office_map_uri
    lat = 38.999647
    lon = -76.89595

    case device
    when :android
      "geo:#{lat},#{lon}"
    when :blackberry
      contact_path(:format => :kml)
    else
      "http://maps.google.com/maps?q=#{lat},#{lon}"
    end
  end

  def contact_path_with_topic
    topic = if @section.try(:service?)
      @section.cached_slug.gsub(/-/, '_')
    else
      'general_inquiry'
    end
    contact_path(:topic => topic)
  end
end
