require 'test_helper'

class Bozzuto::Neighborhoods::TierShufflerTest < ActiveSupport::TestCase
  context 'A neighborhood tier shuffler' do
    described_class = Bozzuto::Neighborhoods::TierShuffler

    before do
      @neighborhood = Neighborhood.make

      @neighborhood.apartment_communities = (1..6).map do |i|
        instance_variable_set("@community_#{i}", ApartmentCommunity.make)
      end

      #@neighborhood.apartment_communities = [@community_1, @community_2, @community_3]

      @community_1.neighborhood_memberships.first.update_attribute(:tier, 1)
      @community_2.neighborhood_memberships.first.update_attribute(:tier, 1)
      @community_3.neighborhood_memberships.first.update_attribute(:tier, 2)
      @community_4.neighborhood_memberships.first.update_attribute(:tier, 2)
      @community_5.neighborhood_memberships.first.update_attribute(:tier, 3)
      @community_6.neighborhood_memberships.first.update_attribute(:tier, 3)
    end

    describe "#shuffled_communities_by_tier" do
      subject { described_class.new(:place => @neighborhood) }

      it "returns all of the communities ordered by tier" do
        shuffled = subject.shuffled_communities_by_tier
        tier1    = shuffled.slice(0..1)
        tier2    = shuffled.slice(2..3)
        tier3    = shuffled.slice(4..5)

        tier1.should include @community_1
        tier1.should include @community_2
        tier2.should include @community_3
        tier2.should include @community_4
        tier3.should include @community_5
        tier3.should include @community_6
      end

      it "shuffles the order of communities within each tier" do
        ordered  = subject.communities
        shuffled = subject.shuffled_communities_by_tier

        shuffled.should_not == ordered
      end
    end
  end
end
