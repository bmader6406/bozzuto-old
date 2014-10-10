require 'test_helper'

class Bozzuto::Neighborhoods::TierShufflerTest < ActiveSupport::TestCase
  context 'A neighborhood tier shuffler' do
    described_class = Bozzuto::Neighborhoods::TierShuffler

    subject { described_class.new(:place => @neighborhood) }

    before do
      @neighborhood = Neighborhood.make

      @neighborhood.apartment_communities = (1..6).map do |i|
        instance_variable_set("@community_#{i}", ApartmentCommunity.make)
      end

      @community_1.neighborhood_memberships.first.update_attribute(:tier, 1)
      @community_2.neighborhood_memberships.first.update_attribute(:tier, 1)
      @community_3.neighborhood_memberships.first.update_attribute(:tier, 2)
      @community_4.neighborhood_memberships.first.update_attribute(:tier, 2)
      @community_5.neighborhood_memberships.first.update_attribute(:tier, 3)
      @community_6.neighborhood_memberships.first.update_attribute(:tier, 3)
    end

    describe "#communities_in_tier" do
      it "only returns results given tier" do
        subject.communities_in_tier(1).should == [@community_1, @community_2]
        subject.communities_in_tier(2).should == [@community_3, @community_4]
        subject.communities_in_tier(3).should == [@community_5, @community_6]
      end
    end

    describe "#shuffled_communities_in_tier" do
      it "only returns results given tier" do
        subject.shuffled_communities_in_tier(1).should =~ [@community_1, @community_2]
        subject.shuffled_communities_in_tier(2).should =~ [@community_3, @community_4]
        subject.shuffled_communities_in_tier(3).should =~ [@community_5, @community_6]
      end
    end

    describe "#shuffled_communities" do
      it "returns all of the communities ordered by tier" do
        shuffled = subject.shuffled_communities
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
        subject.shuffled_communities.should_not == subject.communities
      end
    end
  end
end
