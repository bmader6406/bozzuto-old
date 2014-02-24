require 'test_helper'

class ApartmentCommunitiesHelperTest < ActionView::TestCase
  include CurrencyHelper

  context "ApartmentCommunitiesHelper" do
    describe "#render_apartments_listings" do
      before do
        @communities = [ApartmentCommunity.make, ApartmentCommunity.make]
        @options = {
          :partial    => 'apartment_communities/listing',
          :collection => @communities,
          :as         => :community,
          :locals     => { :use_dnr => false }
        }
      end

      context "and :use_dnr option is not set" do
        it "calls render with the correct options" do
          expects(:render).with(@options)

          render_apartments_listings(@communities)
        end
      end

      context "and :use_dnr option is true" do
        it "calls render with the correct options" do
          @options[:locals][:use_dnr] = true
          expects(:render).with(@options)

          render_apartments_listings(@communities, :use_dnr => true)
        end
      end
    end

    describe "#floor_plan_image" do
      before do
        @plan = ApartmentFloorPlan.make :image_url => 'http://bozzuto.com/blah.jpg'
      end

      it "returns the link" do
        html = HTML::Document.new(floor_plan_image(@plan))

        assert_select html.root, 'a', :count => 1, :href => @plan
        assert_select html.root, 'img', :count => 1, :src => @plan
        assert_select html.root, 'a span', 'View Full-Size'
      end
    end

    describe "#apartment_community_price_range" do
      context "prices aren't present" do
        before do
          @community = stub(:min_rent => nil, :max_rent => nil)
        end

        it "returns an empty string" do
          apartment_community_price_range(@community).should == ''
        end
      end

      context "price is 0" do
        before do
          @community = stub(:min_rent => 0, :max_rent => 100)
        end

        it "returns an empty string" do
          apartment_community_price_range(@community).should == ''
        end
      end

      context "prices are present" do
        before do
          @community = stub(:min_rent => 100, :max_rent => 200)
        end

        it "returns an empty string" do
          apartment_community_price_range(@community).should == '$100 to $200'
        end
      end
    end

    describe "#square_feet" do
      context "value is present" do
        it "returns the floor plan's formatted square footage" do
          square_feet(25).should == "25 Sq Ft"
        end
      end

      context "value isn't present" do
        it "returns an empty string" do
          square_feet(nil).should == ''
        end
      end
    end

    describe '#website_url' do
      it "prepends 'http://' if not present" do
        website_url('google.com').should == 'http://google.com'
        website_url('https://yahoo.com').should == 'https://yahoo.com'
      end
    end

    describe "#walkscore_map_script" do
      before do
        @community = ApartmentCommunity.make(:street_address => '123 Test Dr')
      end

      it "returns the javascript code" do
        walkscore_map_script(@community).should =~ /#{@community.address}/

        walkscore_map_script(@community, :width => 500).should =~ /var ws_width = '500';/

        walkscore_map_script(@community, :height => 700).should =~ /var ws_height = '700';/
      end
    end

    describe "#availability_link" do
      context "community is managed by rent cafe" do
        before do
          @community = ApartmentCommunity.make(:rent_cafe)
        end

        it "returns 'Apply Now' as the link text" do
          availability_link(@community) =~ /Apply Now/
        end
      end

      context "community is managed by anything else" do
        before do
          @community = ApartmentCommunity.make
        end

        it "returns 'Availability' as the link text" do
          availability_link(@community) =~ /Availability/
        end
      end
    end

    describe "#reserve_link" do
      context "plan is managed by rent cafe" do
        before do
          @plan = ApartmentFloorPlan.make(:rent_cafe)
        end

        it "returns 'Apply Now' as the link text" do
          reserve_link(@plan) =~ /Apply Now/
        end
      end

      context "plan is managed by anything else" do
        before do
          @plan = ApartmentFloorPlan.make
        end

        it "returns 'Reserve' as the link text" do
          reserve_link(@plan) =~ /Reserve/
        end
      end
    end
  end
end
