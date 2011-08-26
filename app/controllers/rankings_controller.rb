class RankingsController < SectionContentController
  browser_only!

  layout 'page'

  before_filter :find_section, :find_page, :only => :index

  def index
    @publications = Publication.published.all(:include => { :rank_categories => :ranks })
  end


  private

  def find_section
    @section = Section.about
  end

  def find_page
    @page = @section.pages.published.find 'rankings'
  end
end
