require 'test_helper'

class CommunitySearchTest < ActiveSupport::TestCase
  context 'Bozzuto::CommunitySearch' do
    context 'for a zip code search' do
      setup do
        @apartment_va = ApartmentCommunity.make(:zip_code => '22301')
        @apartment_nc = ApartmentCommunity.make(:zip_code => '27510')
        @home_va = HomeCommunity.make(:zip_code => '22301-5601')
        @home_nc = HomeCommunity.make(:zip_code => '27510')
        
        @search = Bozzuto::CommunitySearch.search('22301')
      end
      
      should 'report a search type of :zip' do
        assert_equal :zip, @search.search_type
      end
      
      should 'correctly report the query' do
        assert_equal '22301', @search.query
      end
      
      should "not return results that don't match the zip code" do
        assert_does_not_contain @search.results, @home_nc
        assert_does_not_contain @search.results, @apartment_nc
      end
      
      should "return result for exact match" do
        assert_contains @search.results, @apartment_va
      end
      
      should "return result for partial match" do
        assert_contains @search.results, @home_va
      end
      
      should 'return correct total number of results' do
        assert_equal 2, @search.total_results_count
      end
    end
    
    context 'for a search matching a community name' do
      setup do
        @apartment_match = ApartmentCommunity.make(:title => 'The Metropolitan')
        @apartment_no_match = ApartmentCommunity.make(:title => 'Bogus')
        @home_match = HomeCommunity.make(:title => 'Metropolitan Village')
        @home_no_match = HomeCommunity.make(:title => 'Bogus Village')
        
        @search = Bozzuto::CommunitySearch.search('Metro')
      end
      
      should 'report a search type of :name' do
        assert_equal :name, @search.search_type
      end
      
      should 'correctly report the query' do
        assert_equal 'Metro', @search.query
      end
      
      should "not return results that don't match the query" do
        assert_does_not_contain @search.all_results, @home_no_match
        assert_does_not_contain @search.all_results, @apartment_no_match
      end
      
      should "return results that match query" do
        assert_contains @search.all_results, @apartment_match
        assert_contains @search.all_results, @home_match
      end
      
      should 'return correct total number of results' do
        assert_equal 2, @search.total_results_count
      end
    end
    
    context 'for a search matching a community name and location' do
      setup do
        @city = City.make(:name => 'Bethesda')
        
        @apartment_match = ApartmentCommunity.make(:title => 'Upstairs at Bethesda Row', :city => @city)
        @apartment_no_match = ApartmentCommunity.make(:title => 'Bogus')
        @home_match = HomeCommunity.make(:title => 'Utopia Village', :city => @city)
        @home_no_match = HomeCommunity.make(:title => 'Bogus Village')
        
        @search = Bozzuto::CommunitySearch.search('Bethesda')
      end
      
      should 'report a search type of :name' do
        assert_equal :name, @search.search_type
      end
      
      should 'correctly report the query' do
        assert_equal 'Bethesda', @search.query
      end
      
      should "not return results that don't match the query" do
        assert_does_not_contain @search.all_results, @home_no_match
        assert_does_not_contain @search.all_results, @apartment_no_match
      end
      
      should "return results that match query by city" do
        assert_contains @search.results[:city], @apartment_match
        assert_contains @search.results[:city], @home_match
      end
      
      should "return results that match query by title" do
        assert_contains @search.results[:title], @apartment_match
      end
      
      should 'return correct total number of results' do
        assert_equal 2, @search.total_results_count
      end
    end
  end
end
