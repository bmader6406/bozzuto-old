module ContactSubmissionsHelper
  def contact_path_with_topic
    topic = if @section.try(:service?)
      @section.cached_slug.gsub(/-/, '_')
    else
      'general_inquiry'
    end
    contact_path(:topic => topic)
  end
end
