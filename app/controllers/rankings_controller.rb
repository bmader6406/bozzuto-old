class RankingsController < ApplicationController
  include Bozzuto::ContentController

  # layout 'page'

  def index
    @publications = Publication.published.all(:include => { :rank_categories => :ranks })
  end


  private

  def find_section
    @section = Section.about
  end
end
