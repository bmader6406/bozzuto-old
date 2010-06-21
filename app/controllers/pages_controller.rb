class PagesController < ApplicationController
  before_filter :find_section, :find_pages

  def show
  end


  private

  def find_pages
    @pages = @section.pages.find(params[:pages])
    @page = @pages.last || @section.pages.first
  end
end
