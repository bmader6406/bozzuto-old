require 'test_helper'

class LandingPageTest < ActiveSupport::TestCase
  context 'LandingPage' do
    setup { @page = LandingPage.make }

    subject { @page }

    should have_and_belong_to_many(:apartment_communities)
    should have_and_belong_to_many(:featured_apartment_communities)
    should have_and_belong_to_many(:home_communities)
    should have_and_belong_to_many(:projects)
    should belong_to(:state)
    should belong_to(:promo)
    should have_many(:popular_property_orderings)
    should have_many(:popular_properties).through(:popular_property_orderings)

    should validate_presence_of(:title)
    should validate_presence_of(:state)
    should validate_uniqueness_of(:title)
    should have_attached_file(:masthead_image)

    context 'with some popular properties' do
      setup do
        @community1 = ApartmentCommunity.make
        @community2 = ApartmentCommunity.make

        @page.apartment_communities << @community1
        @page.apartment_communities << @community2

        @page.popular_properties << @community1
        @page.popular_properties << @community2
      end

      context 'with custom_sort_popular_properties true' do
        setup do
          @page.update_attributes!(:custom_sort_popular_properties => true)
        end

        should 'set position of related LandingPagePopularOrdering when custom_sort_popular_properties is changed to false' do
          @page.update_attributes!(:custom_sort_popular_properties => false)

          @page.popular_property_orderings(true).each do |ordering|
            assert ordering.position.nil?
          end
        end
      end

      should 'set position of related LandingPagePopularProperty when custom_sort_popular_properties is changed to true' do
        @page.update_attributes!(:custom_sort_popular_properties => true)

        @page.popular_property_orderings(true).each do |ordering|
          assert ordering.position?
        end
      end
    end
  end
end
