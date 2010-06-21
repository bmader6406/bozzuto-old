class PagesController < ApplicationController
  def show
    if params[:template]
      @page = Page.find 'services'
      render :template => "pages/#{params[:template]}"
    else
      find_section
      find_pages
    end
  end


  private

  def find_pages
    @pages = @section.pages.find(params[:pages])
    @page = @pages.last || @section.pages.first
  end
end
