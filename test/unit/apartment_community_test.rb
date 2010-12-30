require 'test_helper'

class ApartmentCommunityTest < ActiveSupport::TestCase
  context 'ApartmentCommunity' do
    setup do
      @community = ApartmentCommunity.make
    end

    subject { @community }

    should_have_many :floor_plans, :featured_floor_plans

    should 'respond to named scopes' do
      assert_nothing_raised do
        ApartmentCommunity.with_floor_plan_groups(1).all
        ApartmentCommunity.with_min_price(0).all
        ApartmentCommunity.with_max_price(1000).all
        ApartmentCommunity.with_property_features([1, 2, 3]).all
        ApartmentCommunity.featured_order
      end
    end
    
    should 'be archivable' do
      assert ApartmentCommunity.acts_as_archive?
      assert_nothing_raised do
        ApartmentCommunity::Archive
      end
      assert defined?(ApartmentCommunity::Archive)
      assert ApartmentCommunity::Archive.ancestors.include?(ActiveRecord::Base)
      assert ApartmentCommunity::Archive.ancestors.include?(Property::Archive)
      assert ApartmentCommunity::Archive.ancestors.include?(Community::Archive)
    end

    should "require lead_2_lease email if show_lead_2_lease is true" do
      @community.show_lead_2_lease = true
      @community.lead_2_lease_email = nil
      assert !@community.valid?
      assert @community.errors.on(:lead_2_lease_email).present?

      @community.lead_2_lease_email = 'test@example.com'
      @community.valid?
      assert @community.errors.on(:lead_2_lease_email).blank?
    end
    
    should 'set featured_position when changed to being featured' do
      @community.featured = true
      @community.save!
      assert @community.featured_position.present?
    end
    
    context 'that is featured' do
      setup do
        @community.featured = true
        @community.save!
      end
      
      should 'remove the featured position when they lose their featured status' do
        @community.featured = false
        @community.save!
        assert @community.featured_position.nil?
      end
    end

    context '#nearby_communities' do
      setup do
        @city = City.make
        @communities = []

        3.times do |i|
          @communities << ApartmentCommunity.make(:latitude => i, :longitude => i, :city => @city)
        end
      end

      should "return the closest communities" do
        nearby = @communities[0].nearby_communities
        assert_equal 2, nearby.length
        assert_equal @communities[1], nearby[0]
        assert_equal @communities[2], nearby[1]
      end
    end

    context 'when changing use_market_prices' do
      setup do
        @plan = ApartmentFloorPlan.make(
          :min_effective_rent  => 100,
          :min_market_rent     => 200,
          :max_effective_rent  => 300,
          :max_market_rent     => 400,
          :apartment_community => @community
        )
      end

      should 'update the cached floor plan prices' do
        assert_equal @plan.min_effective_rent, @plan.min_rent
        assert_equal @plan.max_effective_rent, @plan.max_rent

        @community.update_attributes(:use_market_prices => true)
        @plan.reload

        assert_equal @plan.min_market_rent, @plan.min_rent
        assert_equal @plan.max_market_rent, @plan.max_rent
      end
    end
  end
end
