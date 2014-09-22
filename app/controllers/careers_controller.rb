class CareersController < ApplicationController
  include Bozzuto::ContentController

  has_mobile_actions :index

  def index
    @page    = @section.pages.published.first
    @entries = CareersEntry.all(:limit => 4)

    if mobile?
      render 'pages/show'
    else
      render :index, :layout => 'application'
    end
  end
end
