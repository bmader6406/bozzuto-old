require 'test_helper'

class AwardsControllerTest < ActionController::TestCase
  context 'AwardsController' do
    setup do
      @section = Section.make
    end

    context 'a GET to #index' do
      setup do
        5.times do
          Award.make :section => @section
        end
        Award.make(:unpublished, :section => @section)
        @awards = @section.section_awards

        get :index, :section => @section.to_param
      end

      should_respond_with :success
      should_render_template :index
      should_assign_to(:awards) { @awards.published }
    end

    context 'a GET to #show' do
      setup do
        @award = Award.make :section => @section

        get :show, :section => @section.to_param, :award_id => @award.id
      end

      should_respond_with :success
      should_render_template :show
      should_assign_to(:award) { @award }
    end
  end
end
