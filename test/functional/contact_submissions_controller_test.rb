require 'test_helper'

class ContactSubmissionsControllerTest < ActionController::TestCase
  context 'ContactSubmissionsController' do
    setup do
      @section = Section.make(:about)
      @topic = ContactTopic.make
    end

    context 'a GET to #show' do
      all_devices do
        context 'with no topic param' do
          setup do
            get :show, :section => @section.to_param
          end

          should respond_with(:success)
          should render_template(:show)
  # TODO Mark for pending removal in lieu of HyLy form integration
          should assign_to(:submission)
          should assign_to(:section) { @section }
        end

  # TODO Mark for pending removal in lieu of HyLy form integration
        context 'with a topic param' do
          setup do
            get :show,
                :section => @section.to_param,
                :topic   => @topic.to_param
          end

          should 'set the topic on the submission' do
            assigns(:submission).topic.should == @topic
          end
        end
      end

      context 'for KML format' do
        setup do
          get :show,
              :section => @section.to_param,
              :format  => :kml
        end

        should respond_with(:success)
        should render_template(:show)

        should 'render the KML XML' do
          @response.body.should =~ %r{<name>Bozzuto Corporate Office</name>}
          @response.body.should =~ %r{<description>6406 Ivy Lane, Suite 700, Greenbelt, MD 20770</description>}
          @response.body.should =~ %r{<coordinates>39.0089301,-76.8952471,0</coordinates>}
        end
      end
    end

  # TODO Mark for pending removal in lieu of HyLy form integration
    context 'a POST to #create' do
      context 'with missing fields' do
        setup do
          expect {
            post :create,
                 :section            => @section.to_param,
                 :contact_submission => {}
          }.to_not change { ActionMailer::Base.deliveries.count }
        end

        should respond_with(:success)
        should render_template(:show)
        should assign_to(:section) { @section }
      end

      context 'with all fields present' do
        setup do
          @submission = ContactSubmission.make_unsaved :topic => @topic

          expect {
            post :create,
                 :section            => @section.to_param,
                 :contact_submission => @submission.attributes,
                 :topic              => @topic.to_param
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        should respond_with(:redirect)
        should redirect_to('the thank you page') { thank_you_contact_path }
        should assign_to(:section) { @section }

        should 'save the email in the flash' do
          flash[:contact_submission_email].should == @submission.email
        end
      end
    end

    context 'a GET to #thank_you' do
      all_devices do
        setup do
          get :thank_you, :section => @section.to_param
        end

        should respond_with(:success)
        should render_template(:thank_you)
        should assign_to(:section) { @section }
      end
    end
  end
end
