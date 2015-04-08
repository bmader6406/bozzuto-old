require 'test_helper'

module Bozzuto
  class CommunitySearchTest < ActiveSupport::TestCase
    context "Bozzuto::CommunitySearch" do
      before do
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
      end

      describe "#results" do
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
          subject { CommunitySearch.new('title_eq' => 'White House') }

          it "returns false" do
            subject.no_results?.should == false
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
    end
  end
end
