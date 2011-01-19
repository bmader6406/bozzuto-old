require 'test_helper'

class CommunitySearchesHelperTest < ActionView::TestCase
  context '#render_search_results' do
    setup do
      @apartment_community = ApartmentCommunity.make
      @home_community      = HomeCommunity.make
    end

    should 'render the partial with the correct options' do
      expects(:render).with({
        :partial => 'apartment_communities/listing',
        :locals  => { :community => @apartment_community }
      }).returns('')

      expects(:render).with({
        :partial => 'home_communities/listing',
        :locals  => { :community => @home_community }
      }).returns('')

      render_search_results([@apartment_community, @home_community])
    end
  end
end
