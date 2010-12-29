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
end
