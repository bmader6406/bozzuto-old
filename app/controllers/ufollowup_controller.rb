class UfollowupController < ApplicationController
  include Bozzuto::ContentController

  layout 'community'

  skip_before_filter :find_section,
                     :find_news_and_press_section,
                     :only => :show

  def show
    @email     = params[:email]
    @community = Property.friendly.find(params[:apartment_community_id])
  end

  def thank_you
    @email = cookies.delete('ufollowup_email')

    render :thank_you, :layout => 'page'
  end


  private

  def find_section
    @section = Section.friendly.find('apartments')
  end
end
