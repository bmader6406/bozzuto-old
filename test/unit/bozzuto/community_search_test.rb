require 'test_helper'

module Bozzuto
  class CommunitySearchTest < ActiveSupport::TestCase
    context "Bozzuto::CommunitySearch" do
      before do
        create_floor_plan_groups

        @dc = State.make(:code => 'DC', :name => 'Washington, DC')
        @va = State.make(:code => 'VA', :name => 'Virginia')
        @md = State.make(:code => 'MD', :name => 'Maryland')

        @washington = City.make(:name => 'Washington', :state => @dc)
        @fairfax    = City.make(:name => 'Fairfax',    :state => @va)
        @alexandria = City.make(:name => 'Alexandria', :state => @va)
        @bethesda   = City.make(:name => 'Bethesda',   :state => @md)

        @dc_community = ApartmentCommunity.make(:city => @washington, :title => 'White House')
        @va_community = ApartmentCommunity.make(:city => @fairfax,    :title => 'Fairtower')
        @md_community = ApartmentCommunity.make(:city => @bethesda,   :title => 'Escape')
        @featured     = ApartmentCommunity.make(:city => @alexandria, :featured => true)
        @unpublished  = ApartmentCommunity.make(:city => @washington, :published => false)

        ApartmentFloorPlan.make(
          :apartment_community => @dc_community,
          :floor_plan_group    => ApartmentFloorPlanGroup.one_bedroom,
          :min_rent            => 2300,
          :max_rent            => 2500
        )

        ApartmentFloorPlan.make(
          :apartment_community => @va_community,
          :floor_plan_group    => ApartmentFloorPlanGroup.three_bedrooms,
          :min_rent            => 2700,
          :max_rent            => 2800,
        )

        ApartmentFloorPlan.make(
          :apartment_community => @md_community,
          :floor_plan_group    => ApartmentFloorPlanGroup.two_bedrooms,
          :min_rent            => 1000,
          :max_rent            => 1000
        )
      end

      describe "#results" do
        context "when there are matching results for the given search params" do
          subject { CommunitySearch.new('in_state' => @dc.id) }

          it "returns all matching results for the given search params regardless of selected state" do
            subject.results.should == [
              @featured,
              @md_community,
              @va_community,
              @dc_community
            ]
          end
        end

        context "when there are no matching results for the given search params" do
          before do
            @dc_community.fetch_apartment_floor_plan_cache
            @va_community.fetch_apartment_floor_plan_cache
            @md_community.fetch_apartment_floor_plan_cache
          end

          context "but there are relevant communities based on the given minimum price" do
            subject { CommunitySearch.new('with_min_price' => '2900') }

            it "returns the relevant communities" do
              subject.results.should == [@va_community, @dc_community]
            end
          end

          context "but there are relevant communities based on the given maximum price" do
            subject { CommunitySearch.new('with_max_price' => '750.50') }

            it "returns the relevant communities" do
              subject.results.should == [@md_community]
            end
          end

          context "but there are relevant communities based on the given floor plans" do
            subject do
              CommunitySearch.new(
                'having_all_floor_plan_groups' => [
                  ApartmentFloorPlanGroup.two_bedrooms.id.to_s,
                  ApartmentFloorPlanGroup.three_bedrooms.id.to_s
                ]
              )
            end

            it "returns the relevant communities" do
              subject.results.should == [@md_community, @va_community]
            end
          end

          context "and there are no relevant communities" do
            subject { CommunitySearch.new('with_min_price' => '250', 'with_max_price' => '400') }

            it "returns an empty array" do
              subject.results.should == []
            end
          end
        end
      end

      describe "#query" do
        subject { CommunitySearch.new('test' => 'value') }

        before do
          @published_scope = mock('ApartmentCommunity.published')
          @featured_scope  = mock('ApartmentCommunity.featured_order')

          ApartmentCommunity.stubs(:published).returns(@published_scope)
          @published_scope.stubs(:featured_order).returns(@featured_scope)
        end

        it "generates a query object with published communities in featured order with the given search params" do
          @featured_scope.expects(:search).with('test' => 'value')

          subject.query
        end
      end

      describe "#states" do
        context "when a state is not selected" do
          subject { CommunitySearch.new }

          it "returns states ordered by the number of results in each" do
            subject.states.should == [
              @va,
              @md,
              @dc
            ]
          end
        end

        context "when a specific state is selected" do
          subject { CommunitySearch.new('in_state' => @md.id) }

          it "returns states ordered by relevancy (state selected? and number of results in the state)" do
            subject.states.should == [
              @md,
              @va,
              @dc
            ]
          end
        end
      end

      describe "#no_results?" do
        context "when there are no matching communities" do
          subject { CommunitySearch.new('title_eq' => 'no dice') }

          it "returns true" do
            subject.no_results?.should == true
          end
        end

        context "when there are matching communities" do
          subject { CommunitySearch.new('in_state' => @md.id) }

          it "returns false" do
            subject.no_results?.should == false
          end
        end
      end

      describe "#showing_relevant_results?" do
        context "when there are matching communities" do
          subject { CommunitySearch.new('title_eq' => 'White House') }

          it "returns false" do
            subject.showing_relevant_results?.should == false
          end

          context "but none in the given state" do
            subject { CommunitySearch.new('in_state' => @md.id, 'title_eq' => 'White House') }

            it "returns true" do
              subject.showing_relevant_results?.should == true
            end
          end
        end

        context "when there are no matching communities" do
          context "but there are relevant results" do
            subject { CommunitySearch.new('with_any_floor_plan_groups' => [ApartmentFloorPlanGroup.penthouse.id.to_s]) }

            it "returns true" do
              subject.showing_relevant_results?.should == true
            end
          end

          context "and there are showing_relevant relevant results" do
            subject { CommunitySearch.new('with_min_price' => '250', 'with_max_price' => '400') }

            it "returns false" do
              subject.showing_relevant_results?.should == false
            end
          end
        end
      end

      describe "#results_with" do
        subject { CommunitySearch.new }

        it "returns the results matching the given criteria" do
          subject.results_with(state: @va).should == [
            @featured,
            @va_community
          ]
        end
      end

      describe "#results_by_state" do
        subject { CommunitySearch.new }

        it "returns the results by state" do
          subject.results_by_state.should == {
            @va => [@featured, @va_community],
            @md => [@md_community],
            @dc => [@dc_community]
          }
        end
      end

      describe "#result_ids" do
        subject { CommunitySearch.new }

        it "returns the IDs for all the results" do
          subject.result_ids.should == [
            @featured.id,
            @md_community.id,
            @va_community.id,
            @dc_community.id
          ]
        end
      end
    end
  end
end
