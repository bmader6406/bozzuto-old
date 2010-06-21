class PagesController < ApplicationController
  def show
    if params[:template]
      @page = Page.find('services')
      render :template => "pages/#{params[:template]}"
    else
      find_section
      find_page
    end
  end


  private

  def find_page
    @page = if params[:page].empty?
      @section.pages.first
    else
      @section.pages.find_by_path(params[:page].join('/'))
    end
  end
end
