require 'test_helper'

class BuzzesControllerTest < ActionController::TestCase
  context 'BuzzesController' do
    setup do
      @page = Page.make
      @section = Section.make(:about, :pages => [@page])
    end

    context 'a GET to #new' do
      desktop_device do
        setup do
          get :new, :section => 'about-us'
        end

        should render_with_layout(:page)
        should respond_with(:success)
        should render_template(:new)
      end

      mobile_device do
        setup do
          get :new, :section => 'about-us'
        end

        should render_with_layout(:application)
        should respond_with(:success)
        should render_template(:new)
      end
    end

    context 'a GET to #thank_you' do
      desktop_device do
        setup do
          get :thank_you, :section => 'about-us'
        end

        should render_with_layout(:page)
        should respond_with(:success)
        should render_template(:thank_you)
      end

      mobile_device do
        setup do
          get :thank_you, :section => 'about-us'
        end

        should render_with_layout(:application)
        should respond_with(:success)
        should render_template(:thank_you)
      end
    end
  end
end
