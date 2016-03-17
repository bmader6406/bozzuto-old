module ActiveAdmin
  module ApplicationHelper
    def community_select_options
      {
        ApartmentCommunity => ApartmentCommunity.all,
        HomeCommunity      => HomeCommunity.all
      }
    end

    def property_select_options
      community_select_options.merge(Project => Project.all)
    end
  end
end
