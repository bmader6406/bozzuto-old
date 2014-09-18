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
        should assign_to(:buzz)
      end

      mobile_device do
        setup do
          get :new, :section => 'about-us'
        end

        should render_with_layout(:application)
        should respond_with(:success)
        should render_template(:new)
        should assign_to(:buzz)
      end
    end

    context 'a POST to #create' do
      desktop_device do
        context 'with an invalid buzz' do
          setup do
            expect {
              post :create,
                :section => 'about-us',
                :buzz => {}
            }.to_not change { Buzz.count }
          end

          should render_with_layout(:page)
          should respond_with(:success)
          should render_template(:new)

          should 'have errors on buzz' do
            assigns(:buzz).errors[:email].should be_present
          end
        end

        context 'with a valid buzz' do
          setup do
            @buzz = Buzz.make_unsaved

            expect {
              post :create,
                   :section => 'about-us',
                   :buzz    => @buzz.attributes
            }.to change { Buzz.count }.by(1)
          end

          should respond_with(:redirect)
          should redirect_to('the thank you page') { thank_you_buzzes_path }

          should 'save the buzz email in the flash' do
            flash[:buzz_email].should == @buzz.email
          end
        end
      end

      mobile_device do
        context 'with an invalid buzz' do
          setup do
            expect {
              post :create,
                   :section => 'about-us',
                   :buzz => {}
            }.to_not change { Buzz.count }
          end

          should render_with_layout(:application)
          should respond_with(:success)
          should render_template(:new)

          should "have errors on buzz" do
            assigns(:buzz).errors[:email].should be_present
          end
        end
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
