require 'test_helper'

class ManagementCommunitiesControllerTest < ActionController::TestCase
  context 'ManagementCommunitiesController' do
    setup do
      @section = Section.make :title => 'Management'
    end

    context 'a GET to #index' do
      setup do
        @communities = []
        ["alpha", "beta", "gamma"].each do |title|
          @communities << ApartmentCommunity.make(:title => title)
        end
      end

      context 'a no page is present' do
        setup do
          get :index, :section => 'management'
        end

        should_respond_with :success
        should_assign_to(:communities) { @communities }
      end

      context 'and a page is present' do
        setup do
          @page = @section.pages.create(:title => 'Communities', :published => true)
          get :index, :section => 'management'
        end

        should_respond_with :success
        should_assign_to(:communities) { @communities }
        should_assign_to(:page) { @page }
      end
    end
  end
end
