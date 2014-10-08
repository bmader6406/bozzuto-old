require 'test_helper'

class Bozzuto::Neighborhoods::FiltererTest < ActiveSupport::TestCase
  context 'A neighborhoods filterer' do
    described_class = Bozzuto::Neighborhoods::Filterer

    before do
      # neighborhood
      #   - community_1
      #     - rapid_transit
      #   - community_2
      #     - non_smoking
      #   - community_3
      #     - rapid_transit
      #     - non_smoking

      @rapid_transit = PropertyFeature.make(:name => 'Rapid Transit')
      @non_smoking   = PropertyFeature.make(:name => 'Non Smoking')
      @pet_friendly  = PropertyFeature.make(:name => 'Pet Friendly')

      @neighborhood = Neighborhood.make

      @community_1 = ApartmentCommunity.make(:property_features => [@rapid_transit])
      @community_2 = ApartmentCommunity.make(:property_features => [@non_smoking])
      @community_3 = ApartmentCommunity.make(:property_features => [@rapid_transit, @non_smoking])

      @neighborhood.apartment_communities = [@community_1, @community_2, @community_3]

      @membership_1 = @community_1.neighborhood_memberships.first
      @membership_2 = @community_2.neighborhood_memberships.first
      @membership_3 = @community_3.neighborhood_memberships.first
    end

    describe "#amenities" do
      subject { described_class.new(@neighborhood, nil) }

      it "returns only the amenities that exist" do
        subject.amenities.should == [@rapid_transit, @non_smoking, @pet_friendly]
      end
    end

    describe "#current_amenity" do
    end

    describe "#current_filter" do
      context "id matches an existing filter" do
        subject { described_class.new(@neighborhood, @rapid_transit.id) }

        it "returns the filter" do
          subject.current_filter.present?.should == true
          subject.current_filter.amenity.should == @rapid_transit
        end
      end

      context "id doesn't match an existing filter" do
        subject { described_class.new(@neighborhood, 135) }

        it "returns nil" do
          subject.current_filter.should == nil
        end
      end

      describe "#filtered_communities" do
        before do
          @membership_1.update_attributes(:tier => 3)
          @membership_2.update_attributes(:tier => 2)
          @membership_3.update_attributes(:tier => 1)
        end

        context "current filter is set" do
          subject { described_class.new(@neighborhood, @rapid_transit.id) }

          it "returns only the communities with that amenity ordered by tier" do
            subject.filtered_communities.should == [@community_3, @community_1]
          end
        end

        context "current filter isn't set" do
          subject { described_class.new(@neighborhood, nil) }

          it "returns all of the communities ordered by tier" do
            subject.filtered_communities.should == [@community_3, @community_2, @community_1]
          end
        end
      end
    end

    describe "A filter object" do
      before do
        @filterer = described_class.new(@neighborhood, @rapid_transit.id)
      end

      describe "#communities" do
        subject { described_class::Filter.new(@filterer, @rapid_transit) }

        it "returns the right communities" do
          subject.communities.should == [@community_1, @community_3]
        end
      end

      describe "#name_with_count" do
        subject { described_class::Filter.new(@filterer, @rapid_transit) }

        it "returns the name and the count" do
          subject.name_with_count.should == "Rapid Transit (2)"
        end
      end

      describe "#current?" do
        context "filter is current" do
          subject { described_class::Filter.new(@filterer, @rapid_transit) }

          it "returns true" do
            subject.current?.should == true
          end
        end

        context "filter is current" do
          subject { described_class::Filter.new(@filterer, @pet_friendly) }

          it "returns false" do
            subject.current?.should == false
          end
        end
      end

      describe "#any?" do
        context "there are some communities" do
          subject { described_class::Filter.new(@filterer, @rapid_transit) }

          it "returns true" do
            subject.any?.should == true
          end
        end

        context "there are no communities" do
          subject { described_class::Filter.new(@filterer, @pet_friendly) }

          it "returns false" do
            subject.any?.should == false
          end
        end
      end
    end
  end
end
