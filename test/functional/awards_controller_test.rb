require 'test_helper'

class AwardsControllerTest < ActionController::TestCase
  context 'AwardsController' do
    setup do
      @section = Section.make
    end

    context 'a GET to #index' do
      all_devices do
        setup do
          5.times { Award.make(:sections => [@section]) }
          Award.make(:unpublished, :sections => [@section])
          @awards = @section.awards

          get :index, :section => @section.to_param
        end

        should respond_with(:success)
        should render_template(:index)
        should assign_to(:awards) { @awards.published }
      end
    end

    context 'a GET to #show' do
      all_devices do
        setup do
          @award = Award.make :sections => [@section]

          get :show, :section => @section.to_param, :id => @award.id
        end

        should respond_with(:success)
        should render_template(:show)
        should assign_to(:award) { @award }
      end
    end
  end
end
