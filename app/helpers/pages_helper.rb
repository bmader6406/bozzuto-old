module PagesHelper
  def render_aside
    partial = "pages/#{@section.cached_slug.gsub(/-/, '_')}_aside"
    render :partial => partial
  rescue ActionView::MissingTemplate
    Rails.logger.debug "Couldn't find partial #{partial}"
    nil
  end
end
