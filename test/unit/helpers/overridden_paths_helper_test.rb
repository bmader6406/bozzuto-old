require 'test_helper'

class OverriddenPathsHelperTest < ActionView::TestCase
  context 'OverriddenPathsHelper' do
    setup do
      @section = Section.make
      @service = Section.make(:service)
    end

    context '#property_path' do
      context "when property is ApartmentCommunity" do
        setup do
          @property = ApartmentCommunity.make
        end

        should 'return the property' do
          assert_equal apartment_community_path(@property), property_path(@property)
        end
      end

      context "when property is HomeCommunity" do
        setup do
          @property = HomeCommunity.make
        end

        should 'return the property' do
          assert_equal home_community_path(@property), property_path(@property)
        end
      end

      context 'when property is Project' do
        setup do
          @project = Project.make(:section => @section)
        end

        should 'return project_path' do
          assert_equal project_path(@project.section, @project),
            property_path(@project)
        end
      end
    end

    %w(url path).each do |type|
      context "#contact_community_#{type}" do
        context 'when community is an ApartmentCommunity' do
          setup { @community = ApartmentCommunity.make }

          should 'return the correct contact link' do
            assert_equal send("apartment_community_contact_#{type}", @community),
              send("contact_community_#{type}", @community)
          end
        end

        context 'when community is a HomeCommunity' do
          setup { @community = HomeCommunity.make }

          should 'return the correct contact link' do
            assert_equal send("home_community_contact_#{type}", @community),
              send("contact_community_#{type}", @community)
          end
        end
      end

      context "#schedule_tour_community_#{type}" do
        context "on a community with a schedule_tour_url set" do
          setup do
            @community = ApartmentCommunity.make({
              :schedule_tour_url => 'http://www.example.com/tour'
            })
          end

          should "return the correct tour link" do
            assert_equal 'http://www.example.com/tour',
              send("schedule_tour_community_#{type}", @community)
          end
        end

        context 'when community is an ApartmentCommunity' do
          setup { @community = ApartmentCommunity.make }

          should 'return the correct contact link' do
            assert_equal send("apartment_community_contact_#{type}", @community),
              send("schedule_tour_community_#{type}", @community)
          end
        end

        context 'when community is a HomeCommunity' do
          setup { @community = HomeCommunity.make }

          should 'return the correct contact link' do
            assert_equal send("home_community_contact_#{type}", @community),
              send("schedule_tour_community_#{type}", @community)
          end
        end
      end
    end

    describe "#place_path" do
      before do
        @neighborhood = Neighborhood.make
        @area         = @neighborhood.area
        @metro        = @area.metro
      end

      context "place is a metro" do
        it "returns the path" do
          place_path(@metro).should == metro_path(@metro)
        end
      end

      context "place is an area" do
        it "returns the path" do
          place_path(@area).should == area_path(@metro, @area)
        end
      end

      context "place is a neighborhood" do
        it "returns the path" do
          place_path(@neighborhood).should == neighborhood_path(@metro, @area, @neighborhood)
        end
      end
    end
  end
end
