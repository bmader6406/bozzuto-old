class LeadersController < SectionContentController
  browser_only!

  layout "application"

  before_filter :find_section, :find_page, :only => :index

  def index
    @leadership_groups = LeadershipGroup.all
    @leaders = Leader.all
  end


  private

  def find_section
    @section = Section.about
  end

  def find_page
    @page = begin
      @section.pages.published.find 'leadership'
    rescue
      nil
    end
  end
end
