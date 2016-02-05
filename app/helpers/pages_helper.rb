module PagesHelper
  def mobile_back_link_for(section, page)
    if page.first?
      # overview page

      if section.service?
        # for a service - go back to Services
        name = 'Our Services'
        url  = '/services'
      else
        # for a section - go back to Home
        name = 'Home'
        url  = root_path
      end
    else
      # any other page

      if page.ancestors.any?
        # page with ancestors - go back to Parent
        parent = page.ancestors.last
        name = parent.title
        url  = page_path(section, parent)
      else
        # root level page - go back to Overview
        name = section.title
        url  = page_path(section)
      end
    end

    link_to name, url, :class => 'go-back'
  end

  def render_aside
    partial = "pages/#{@section.slug.gsub(/-/, '_')}_aside"
    render :partial => partial
  rescue ActionView::MissingTemplate
    Rails.logger.debug "Couldn't find partial #{partial}"
    nil
  end

  def about_and_services_slideshow_attrs
    if ['about-us', 'services'].include?(@section.slug) && @page == @section.pages.published.first
      raw(%{data-sync="true" data-interval="8000"})
    end
  end
end
