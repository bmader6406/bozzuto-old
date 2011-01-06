module LandingPagesHelper
  def popular_property_class(property)
    property.class.to_s.underscore.gsub(/_/, '-')
  end
  
  def apartments_by_section(id_name, title, records, &block)
    render :partial => 'apartments_by', :locals => {
      :id_name => id_name,
      :title => title,
      :records => records,
      :list_item_link => block
    }
  end
  
  def apartments_by_region
    apartments_by_section('region', 'By Region', LandingPage.published.visible_for_list.ascend_by_title) do |region|
      link_to region.title, landing_page_path(region)
    end
  end
  
  def apartments_by(location_type)
    title = "in #{@state.name} By #{location_type}"
    records = @state.send(location_type.downcase.pluralize).ordered_by_name
    apartments_by_section(location_type.downcase, title, records) do |item|
      link_to item.name, apartment_communities_path("search[#{location_type.downcase}_id]" => item.id)
    end
  end
end
