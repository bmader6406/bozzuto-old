module SearchHelper
  def route_for_result(search_result)
    case search_result
    when Area
      area_path(metro_id: search_result.metro_id, id: search_result.id)
    when PressRelease, NewsPost, Award
      self.send("#{search_result.class.model_name.singular_route_key}_path",
        section: (search_result.sections.first || Section.about),
        id:      search_result.id
      )
    when Neighborhood
      neighborhood_path(metro_id: search_result.area.metro_id, area_id: search_result.area.id, id: search_result.id)
    when BozzutoBlogPost
      search_result.url
    else
      search_result
    end
  end
end
