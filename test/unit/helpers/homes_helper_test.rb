require 'test_helper'

class HomesHelperTest < ActionView::TestCase
  context '#render_homes_mobile_listings' do
    setup do
      @community = HomeCommunity.make
      @home      = Home.make(:home_community => @community)
    end

    should 'render the partial with the correct options' do
      expects(:render).with({
        :partial    => 'homes/listing',
        :locals     => {
          :community => @community,
          :home      => @home
        }
      })

      render_homes_mobile_listings(@community)
    end
  end
end
