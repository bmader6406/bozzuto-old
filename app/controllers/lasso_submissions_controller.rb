class LassoSubmissionsController < ApplicationController
  has_mobile_actions :show, :thank_you

  before_filter :find_community

  layout :detect_mobile_layout

  def show
  end

  def thank_you
    @email = cookies.delete('lasso_email')
  end


  private

  def find_community
    @community = HomeCommunity.find(params[:home_community_id])
    @page = @community.contact_page
  end
end
