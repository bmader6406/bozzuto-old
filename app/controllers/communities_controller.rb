class CommunitiesController < ApplicationController
  before_filter :find_community

  def show
  end

  def features
  end

  def media
  end

  def neighborhood
  end

  def promotions
  end

  def contact
  end


  private

    def find_community
      @community = Community.find(params[:id])
    end
end
