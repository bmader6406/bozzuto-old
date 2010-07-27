class LeadersController < SectionContentController
  layout "application"

  before_filter :find_section, :find_page, :only => :index

  def index
    @leadership_groups = LeadershipGroup.all
    @leaders = Leader.all
  end


  private

  def find_section
    @section = Section.find 'about-us'
  end

  def find_page
    @page = begin
      @section.pages.find 'leadership'
    rescue
      nil
    end
  end
end
