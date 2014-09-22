class LeadersController < ApplicationController
  include Bozzuto::ContentController

  layout "application"

  before_filter :find_page

  def index
    @leadership_groups = LeadershipGroup.all
    @leaders = Leader.all
  end

  def show
    @leader = Leader.find(params[:id])
  end

  private

  def find_section
    @section = Section.about
  end

  def find_page
    @page = begin
      @section.pages.published.find 'leadership'
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end
end
