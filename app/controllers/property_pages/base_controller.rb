module PropertyPages
  class BaseController < ApplicationController
    class_attribute :property_page_type

    before_filter :find_community

    def show
      @page = @community.send("#{property_page_type}_page")

      render_404 if @page.blank?
    end


    private

    def find_community
      klass, community_id = if params[:apartment_community_id].present?
        [ApartmentCommunity, params[:apartment_community_id]]
      else
        [HomeCommunity, params[:home_community_id]]
      end

      @community = find_property(klass, community_id)
    end
  end
end
