class AwardsController < ApplicationController
  include Bozzuto::ContentController

  before_filter :find_awards, :only => :index
  before_filter :find_award, :only => :show

  def index
  end

  def show
  end


  private

  def find_awards
    @awards = section_awards.paginate(:page => page_number)
  end

  def find_award
    @award = section_awards.find(params[:id])
  end
end
