require 'test_helper'

class ApartmentContactSubmissionsControllerTest < ActionController::TestCase
  context 'ApartmentContactSubmissionsController' do
    context 'community is under construction' do
      setup do
        @community = ApartmentCommunity.make(:under_construction => true)
      end

      context 'GET to #show' do
        context 'with a community that is not published' do
          setup { @community.update_attribute(:published, false) }

          browser_context do
            setup do
              get :show, :apartment_community_id => @community.to_param
            end

            should_respond_with :not_found
          end

          mobile_context do
            setup do
              get :show,
                :apartment_community_id => @community.to_param,
                :format                 => :mobile
            end

            should_respond_with :not_found
          end
        end

        context 'with a contact page' do
          setup do
            @page = PropertyContactPage.make(:property => @community)
          end

          browser_context do
            setup do
              get :show, :apartment_community_id => @community.to_param
            end

            should_respond_with :success
            should_render_with_layout :community
            should_render_template :show
            should_assign_to :submission
            should_assign_to(:page) { @page }
          end

          mobile_context do
            setup do
              get :show,
                :apartment_community_id => @community.to_param,
                :format                 => :mobile
            end

            should_respond_with :success
            should_render_with_layout :application
            should_render_template :show
            should_assign_to :submission
            should_assign_to(:page) { @page }
          end
        end

        context 'without a contact page' do
          browser_context do
            setup do
              get :show, :apartment_community_id => @community.to_param
            end

            should_respond_with :success
            should_render_with_layout :community
            should_render_template :show
            should_assign_to :submission
            should_not_assign_to :page
          end

          mobile_context do
            setup do
              get :show,
                :apartment_community_id => @community.to_param,
                :format                 => :mobile
            end

            should_respond_with :success
            should_render_with_layout :application
            should_render_template :show
            should_assign_to :submission
            should_not_assign_to :page
          end
        end
      end
      
      context 'POST to #create' do
        context 'with an invalid submission' do
          browser_context do
            setup do
              @submission = UnderConstructionLead.new

              post :create,
                :apartment_community_id => @community.to_param,
                :submission             => @submission.attributes
            end

            should_respond_with :success
            should_render_with_layout :community
            should_render_template :show
            should_assign_to :submission

            should 'have errors on the submission' do
              assert assigns(:submission).errors.count > 0
            end
          end

          mobile_context do
            context 'with an invalid submission' do
              setup do
                @submission = UnderConstructionLead.new

                post :create,
                  :apartment_community_id => @community.to_param,
                  :submission             => @submission.attributes,
                  :format                 => :mobile
              end

              should_respond_with :success
              should_render_with_layout :application
              should_render_template :show
              should_assign_to :submission

              should 'have errors on the submission' do
                assert assigns(:submission).errors.count > 0
              end
            end
          end
        end

        context 'with a valid submission' do
          browser_context do
            setup do
              @submission = UnderConstructionLead.make_unsaved

              post :create,
                :apartment_community_id => @community.to_param,
                :submission             => @submission.attributes
            end

            should_respond_with :redirect
            should_redirect_to('the contact path') { thank_you_apartment_community_contact_path(@community) }
            should_change('lead count', :by => 1) { UnderConstructionLead.count }
            should_assign_to :submission

            should 'save the email in the flash' do
              assert_equal @submission.email, flash[:apartment_contact_email]
            end
          end

          mobile_context do
            setup do
              @submission = UnderConstructionLead.make_unsaved

              post :create,
                :apartment_community_id => @community.to_param,
                :submission             => @submission.attributes,
                :format                 => :mobile
            end

            should_respond_with :redirect
            should_redirect_to('the contact path') { thank_you_apartment_community_contact_path(@community) }
            should_assign_to :submission
            should_change('lead count', :by => 1) { UnderConstructionLead.count }

            should 'save the email in the flash' do
              assert_equal @submission.email, flash[:apartment_contact_email]
            end
          end
        end
      end

      context 'GET to #thank_you' do
        browser_context do
          setup do
            get :thank_you, :apartment_community_id => @community.to_param
          end

          should_respond_with :success
          should_render_with_layout :community
          should_render_template :thank_you
          should_assign_to :community
        end

        mobile_context do
          setup do
            get :thank_you,
              :apartment_community_id => @community.to_param,
              :format                 => :mobile
          end

          should_respond_with :success
          should_render_with_layout :application
          should_render_template :thank_you
          should_assign_to :community
        end
      end
    end


    context 'community is showing lead2lease form' do
      setup do
        @community = ApartmentCommunity.make(:show_lead_2_lease => true, :lead_2_lease_email => 'bruce@wayne.com')
      end

      context 'GET to #show' do
        context 'with a contact page' do
          setup do
            @page = PropertyContactPage.make(:property => @community)
          end

          browser_context do
            setup do
              get :show, :apartment_community_id => @community.to_param
            end

            should_respond_with :success
            should_render_with_layout :community
            should_render_template :show
            should_assign_to :submission
            should_assign_to(:page) { @page }
          end

          mobile_context do
            setup do
              get :show,
                :apartment_community_id => @community.to_param,
                :format                 => :mobile
            end

            should_respond_with :success
            should_render_with_layout :application
            should_render_template :show
            should_assign_to :submission
            should_assign_to(:page) { @page }
          end
        end

        context 'without a contact page' do
          browser_context do
            setup do
              get :show, :apartment_community_id => @community.to_param
            end

            should_respond_with :success
            should_render_with_layout :community
            should_render_template :show
            should_assign_to :submission
            should_not_assign_to :page
          end

          mobile_context do
            setup do
              get :show,
                :apartment_community_id => @community.to_param,
                :format                 => :mobile
            end

            should_respond_with :success
            should_render_with_layout :application
            should_render_template :show
            should_assign_to :submission
            should_not_assign_to :page
          end
        end
      end
      
      context 'POST to #create' do
        context 'with an invalid submission' do
          browser_context do
            setup do
              @submission = Lead2LeaseSubmission.new

              post :create,
                :apartment_community_id => @community.to_param,
                :submission             => @submission.attributes
            end

            should_respond_with :success
            should_render_with_layout :community
            should_render_template :show
            should_assign_to :submission

            should 'have errors on the submission' do
              assert assigns(:submission).errors.count > 0
            end
          end

          mobile_context do
            context 'with an invalid submission' do
              setup do
                @submission = Lead2LeaseSubmission.new

                post :create,
                  :apartment_community_id => @community.to_param,
                  :submission             => @submission.attributes,
                  :format                 => :mobile
              end

              should_respond_with :success
              should_render_with_layout :application
              should_render_template :show
              should_assign_to :submission

              should 'have errors on the submission' do
                assert assigns(:submission).errors.count > 0
              end
            end
          end
        end

        context 'with a valid submission' do
          browser_context do
            setup do
              @submission = Lead2LeaseSubmission.make_unsaved

              post :create,
                :apartment_community_id => @community.to_param,
                :submission             => @submission.attributes
            end

            should_assign_to :submission
            should_respond_with :redirect
            should_redirect_to('the contact path') { thank_you_apartment_community_contact_path(@community) }

            should_change('mail deliveries', :by => 1) { ActionMailer::Base.deliveries.count }

            should 'save the email in the flash' do
              assert_equal @submission.email, flash[:apartment_contact_email]
            end
          end

          mobile_context do
            setup do
              @submission = Lead2LeaseSubmission.make_unsaved

              post :create,
                :apartment_community_id => @community.to_param,
                :submission             => @submission.attributes,
                :format                 => :mobile
            end

            should_assign_to :submission
            should_respond_with :redirect
            should_redirect_to('the contact path') { thank_you_apartment_community_contact_path(@community) }

            should_change('mail deliveries', :by => 1) { ActionMailer::Base.deliveries.count }

            should 'save the email in the flash' do
              assert_equal @submission.email, flash[:apartment_contact_email]
            end
          end
        end
      end

      context 'GET to #thank_you' do
        browser_context do
          setup do
            get :thank_you, :apartment_community_id => @community.to_param
          end

          should_respond_with :success
          should_render_with_layout :community
          should_render_template :thank_you
          should_assign_to :community
        end

        mobile_context do
          setup do
            get :thank_you,
              :apartment_community_id => @community.to_param,
              :format                 => :mobile
          end

          should_respond_with :success
          should_render_with_layout :application
          should_render_template :thank_you
          should_assign_to :community
        end
      end
    end
  end
end
