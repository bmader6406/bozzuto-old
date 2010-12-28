require 'test_helper'

class LandingPageTest < ActiveSupport::TestCase
  context 'LandingPage' do
    setup do
      @page = LandingPage.make
    end

    subject { @page }

    should_have_and_belong_to_many :apartment_communities,
      :featured_apartment_communities,
      :home_communities,
      :projects
    should_belong_to :state, :promo
    should_have_many :popular_properties
    should_have_many :popular_properties_properties, :through => :popular_properties

    should_validate_presence_of :title, :state
    should_validate_uniqueness_of :title
    should_have_attached_file :masthead_image
    
    context 'with some popular properties' do
      setup do
        @community1 = ApartmentCommunity.make
        @community2 = ApartmentCommunity.make
        @page.apartment_communities << @community1
        @page.apartment_communities << @community2
        @page.popular_properties_properties << @community1
        @page.popular_properties_properties << @community2
      end
      
      context 'with custom_sort_popular_properties true' do
        setup do
          @page.update_attributes!(:custom_sort_popular_properties => true)
        end
        
        should 'set position of related LandingPagePopularProperty when custom_sort_popular_properties is changed to false' do
          @page.update_attributes!(:custom_sort_popular_properties => false)
          @page.popular_properties(true).each do |popular_property|
            assert popular_property.position.nil?
          end
        end
      end
      
      should 'set position of related LandingPagePopularProperty when custom_sort_popular_properties is changed to true' do
        @page.update_attributes!(:custom_sort_popular_properties => true)
        @page.popular_properties(true).each do |popular_property|
          assert popular_property.position?
        end
      end
      
      
    end
  end
end
