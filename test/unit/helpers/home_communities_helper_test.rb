require 'test_helper'

class HomeCommunitiesHelperTest < ActionView::TestCase
  context '#render_homes_listings' do
    setup do
      @communities = [HomeCommunity.make, HomeCommunity.make]
      @options = {
        :partial    => 'home_communities/listing',
        :collection => @communities,
        :as         => :community,
        :locals     => { :use_dnr => false }
      }
    end

    context 'and :use_dnr option is not set' do
      should 'call render with the correct options' do
        expects(:render).with(@options)

        render_homes_listings(@communities)
      end
    end

    context 'and :use_dnr option is true' do
      should 'call render with the correct options' do
        @options[:locals][:use_dnr] = true
        expects(:render).with(@options)

        render_homes_listings(@communities, :use_dnr => true)
      end
    end
  end


  context '#zillow_mortgage_calculator' do
    should 'return the Zillow code' do
      assert_match /Zillow/, zillow_mortgage_calculator
    end

    should 'be marked html_safe' do
      assert zillow_mortgage_calculator.html_safe?
    end
  end


  context '#tracking_pixels' do
    context 'when tracking a community that is not a home community' do
      setup do
        @community = ApartmentCommunity.make_unsaved
      end

      should 'return nil' do
        assert_nil tracking_pixels(@community)
      end
    end

    context 'when tracking a community that is a home community' do
      [79, 81, 220].each do |id|
        context "that has id #{id}" do
          setup do
            @community = HomeCommunity.make_unsaved :id => id
          end

          should 'return the tracking pixels' do
            assert_match /<img.*<img/, tracking_pixels(@community)
          end
        end
      end

      context 'and home community does not have tracking pixels' do
        setup do
          @community = HomeCommunity.make_unsaved :id => 1000
        end

        should 'return an empty string' do
          assert_equal '', tracking_pixels(@community)
        end
      end
    end
  end
end
