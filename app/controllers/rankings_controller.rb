class RankingsController < SectionContentController
  # layout 'page'

  def index
    @publications = Publication.published.all(:include => { :rank_categories => :ranks })
  end


  private

  def find_section
    @section = Section.about
  end
end
