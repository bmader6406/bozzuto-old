module SearchHelper
  def route_for_result(search_result)
    case search_result
    when Area
      area_path(metro_id: search_result.metro, id: search_result)
    when PressRelease, NewsPost, Award
      self.send("#{search_result.class.model_name.singular_route_key}_path",
        section: (search_result.sections.first || Section.about),
        id:      search_result
      )
    when Project
      featured_project_path(search_result)
    when Neighborhood
      neighborhood_path(metro_id: search_result.area.metro, area_id: search_result.area, id: search_result)
    when BozzutoBlogPost
      search_result.url
    else
      search_result
    end
  end
end
