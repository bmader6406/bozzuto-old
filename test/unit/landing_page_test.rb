require 'test_helper'

class LandingPageTest < ActiveSupport::TestCase
  context 'LandingPage' do
    setup { @page = LandingPage.make }

    subject { @page }

    should_have_and_belong_to_many :apartment_communities,
      :featured_apartment_communities,
      :home_communities,
      :projects
    should_belong_to :state, :promo
    should_have_many :popular_property_orderings
    should_have_many :popular_properties, :through => :popular_property_orderings

    should_validate_presence_of :title, :state
    should_validate_uniqueness_of :title
    should_have_attached_file :masthead_image

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
