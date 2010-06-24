class AwardsController < ApplicationController
  layout 'page'

  before_filter :find_section
  before_filter :find_awards, :only => :index
  before_filter :find_award, :only => :show

  def index
  end

  def show
  end


  private

  def find_awards
    @awards = @section.section_awards.published.paginate(:page => params[:page])
  end

  def find_award
    @award = @section.section_awards.published.find(params[:award_id])
  end
end
