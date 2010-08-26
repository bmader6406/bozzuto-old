class UfollowupController < SectionContentController
  layout 'community'

  skip_before_filter :find_section, :find_news_and_press_section,
    :only => :show

  def show
    @email = params[:email]
    @community = Property.find(params[:id])
  end

  def thank_you
    render :thank_you, :layout => 'page'
  end


  private

  def find_section
    @section = Section.find 'apartments'
  end
end
