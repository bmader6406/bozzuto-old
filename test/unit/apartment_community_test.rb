require 'test_helper'

class ApartmentCommunityTest < ActiveSupport::TestCase
  context 'An Apartment Community' do
    setup do
      @community = ApartmentCommunity.make
    end

    subject { @community }

    should_have_many :floor_plans, :featured_floor_plans
    should_have_many :floor_plan_groups, :through => :floor_plans
    
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
        @city        = City.make
        @communities = []

        3.times do |i|
          @communities << ApartmentCommunity.make(
            :latitude  => i,
            :longitude => i,
            :city      => @city
          )
        end

        @unpublished = ApartmentCommunity.make(
          :latitude  => 3,
          :longitude => 3,
          :published => false,
          :city      => @city
        )
      end

      should "return the closest communities" do
        nearby = @communities[0].nearby_communities

        assert_equal 2, nearby.length
        assert_equal @communities[1], nearby[0]
        assert_equal @communities[2], nearby[1]
      end

      should 'not include unpublished communities' do
        assert !@communities.include?(@unpublished)
      end
    end

    context '#managed_by_vaultware?' do
      setup { @community = ApartmentCommunity.make }

      context 'when community is managed by Vaultware' do
        setup { @community.vaultware_id = 123 }

        should 'be true' do
          assert @community.managed_by_vaultware?
        end
      end

      context 'when community is not managed by Vaultware' do
        should 'be false' do
          assert !@community.managed_by_vaultware?
        end
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

    context '#merge' do
      context 'when receiver is a vaultware-managed community' do
        setup { @community.vaultware_id = 123 }

        should 'raise an exception' do
          begin
            @community.merge(nil)
            assert false, 'Expected an exception'
          rescue RuntimeError => e
            assert_equal 'Receiver must not be a Vaultware-managed community', e.message
          end
        end
      end

      context 'when receiver is not a vaultware-managed community' do
        setup do
          @community = ApartmentCommunity.make
          @other     = ApartmentCommunity.make
        end

        context 'and other community is not Vaultware-managed' do
          should 'raise an exception' do
            begin
              @community.merge(@other)
              assert false, 'Expected an exception'
            rescue RuntimeError => e
              assert_equal 'Argument must be a Vaultware-managed community', e.message
            end
          end
        end

        context 'and other community is Vaultware-managed' do
          setup do
            #configure community
            @community = ApartmentCommunity.make(
              :title            => 'Receiver',
              :street_address   => '123 Test Dr',
              :city             => City.make,
              :county           => County.make,
              :availability_url => 'http://google.com'
            )

            @community_floor_plans = [
              ApartmentFloorPlan.make(:apartment_community => @community),
              ApartmentFloorPlan.make(:apartment_community => @community)
            ]


            # configure other community
            @other = ApartmentCommunity.make(
              :title            => 'Vaultware-managed',
              :street_address   => '456 Test Dr',
              :city             => City.make,
              :county           => County.make,
              :availability_url => 'http://yahoo.com',
              :vaultware_id     => 123
            )

            @other_floor_plans = [
              ApartmentFloorPlan.make(:apartment_community => @other),
              ApartmentFloorPlan.make(:apartment_community => @other),
              ApartmentFloorPlan.make(:apartment_community => @other)
            ]

            # raise "community: #{@community.id} / other: #{@other.id}"
            @community.merge(@other)
            @community.reload
          end

          should "update the receiver's attributes" do
            attrs = ApartmentCommunity::VAULTWARE_ATTRIBUTES.reject { |attr| attr == :floor_plans }

            attrs.each { |attr| assert_equal @other.send(attr), @community.send(attr) }
          end

          should 'set the Vaultware ID of the receiver' do
            assert_equal @other.vaultware_id, @community.vaultware_id
          end

          should "delete the receiver's floor plans" do
            @community_floor_plans.each { |plan|
              assert_nil ApartmentFloorPlan.find_by_id(plan.id)
            }
          end

          should "not delete other's floor plans" do
            @other_floor_plans.each { |plan|
              assert ApartmentFloorPlan.find_by_id(plan.id)
            }
          end

          should 'assign the floor plans to the receiver' do
            assert_equal @other_floor_plans, @community.floor_plans(true)
          end

          should 'destroy the other record' do
            assert @other.destroyed?
          end
        end
      end
    end

  end

  context 'The ApartmentCommunity class' do
    should 'respond to named scopes' do
      assert_nothing_raised do
        ApartmentCommunity.with_floor_plan_groups(1).all
        ApartmentCommunity.with_min_price(0).all
        ApartmentCommunity.with_max_price(1000).all
        ApartmentCommunity.with_property_features([1, 2, 3]).all
        ApartmentCommunity.featured_order
      end
    end

    context 'managed_by_vaultware named scope' do
      setup do
        @managed     = ApartmentCommunity.make(:vaultware_id => 123)
        @non_managed = ApartmentCommunity.make
      end

      should 'return only the managed communities' do
        assert_equal [@managed], ApartmentCommunity.managed_by_vaultware.all
      end
    end
  end
end
