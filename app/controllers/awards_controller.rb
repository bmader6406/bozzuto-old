class AwardsController < SectionContentController
  before_filter :find_awards, :only => :index
  before_filter :find_award, :only => :show

  def index
  end

  def show
  end


  private

  def find_awards
    @awards = section_awards.paginate(:page => params[:page])
  end

  def find_award
    @award = section_awards.find(params[:award_id])
  end
end
