require 'test_helper'

class BuzzesControllerTest < ActionController::TestCase
  context 'BuzzesController' do
    setup do
      @page = Page.make
      @section = Section.make(:about, :pages => [@page])
    end

    context 'a GET to #new' do
      setup { get :new, :section => 'about-us' }

      should_respond_with :success
      should_render_template :new
      should_assign_to :buzz
    end

    context 'a POST to #create' do
      context 'with an invalid buzz' do
        setup do
          post :create,
            :section => 'about-us',
            :buzz => {}
        end

        should_respond_with :success
        should_render_template :new
        should_not_change('the buzz count') { Buzz.count }
        should 'have errors on buzz' do
          assert assigns(:buzz).errors.on(:email)
        end
      end

      context 'with a valid buzz' do
        setup do
          @buzz = Buzz.make_unsaved

          post :create,
            :section => 'about-us',
            :buzz    => @buzz.attributes
        end

        should_respond_with :redirect
        should_redirect_to('the thank you page') { thank_you_buzz_path }
        should_change('the buzz count', :by => 1) { Buzz.count }
        should 'save the buzz email in the flash' do
          assert_equal @buzz.email, flash[:buzz_email]
        end
      end
    end

    context 'a GET to #thank_you' do
      setup { get :thank_you, :section => 'about-us' }

      should_respond_with :success
      should_render_template :thank_you
    end
  end
end
