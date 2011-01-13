require 'test_helper'

class ApartmentFloorPlanGroupsHelperTest < ActionView::TestCase
  context '#render_floor_plan_group_mobile_listings' do
    setup do
      @groups = ApartmentFloorPlanGroup.all
      @community = ApartmentCommunity.make
    end

    should 'render the partial with the correct options' do
      @community.floor_plans_by_group.each do |group, plans_in_group|
        expects(:render).with({
          :partial    => 'apartment_floor_plan_groups/listing',
          :locals     => { 
            :community => @community,
            :group => group,
            :plans_in_group => plans_in_group
          }
        })
      end

      render_floor_plan_group_mobile_listings(@community)
    end
  end

  context '#floor_plan_group_link' do
    setup do
      @community = ApartmentCommunity.make :availability_url => 'http://viget.com/'
    end

    context 'when group is a penthouse' do
      setup { @group = ApartmentFloorPlanGroup.penthouse }

      should 'return the base availability url' do
        link = HTML::Document.new(floor_plan_group_link(@community, @group, 2))
        assert_select link.root, 'a', :href => @community.availability_url
      end
    end

    context 'when group is not a penthouse' do
      setup do
        @group = ApartmentFloorPlanGroup.one_bedroom
        @beds = 2
      end

      should 'return the availability url with beds param' do
        link = HTML::Document.new(floor_plan_group_link(@community, @group, @beds))
        assert_select link.root, 'a',
          :href => "#{@community.availability_url}?beds=#{@beds}"
      end
    end
  end
  
  context '#floor_plan_group_pluralize' do
    setup { @name = '2 Bedrooms' }

    context 'when count is 1' do
      should 'send #singularize' do
        assert_equal @name.singularize, floor_plan_group_pluralize(1, @name)
      end
    end

    context 'when count is greater than 1' do
      should 'send #pluralize' do
        assert_equal @name.pluralize, floor_plan_group_pluralize(2, @name)
      end
    end
  end
end
