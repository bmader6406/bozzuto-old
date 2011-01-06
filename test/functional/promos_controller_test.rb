require 'test_helper'

class PromosControllerTest < ActionController::TestCase
  context 'a GET to #index' do
    setup do
      @active_promo  = Promo.make :active
      @expired_promo = Promo.make :expired
    end

    context 'with a home community' do
      browser_context do
        setup do
          @community = HomeCommunity.make :promo => @active_promo
          get :index, :home_community_id => @community.to_param
        end

        should_respond_with :redirect
        should_redirect_to('the home community page') { @community }
      end

      mobile_context do
        context 'with an expired promo' do
          setup do
            @community = HomeCommunity.make :promo => @expired_promo
            get :index,
              :home_community_id => @community.to_param,
              :format => :mobile
          end

          should_respond_with :redirect
          should_redirect_to('the home community page') { @community }
        end

        context 'with an active promo' do
          setup do
            @community = HomeCommunity.make :promo => @active_promo
            get :index,
              :home_community_id => @community.to_param,
              :format => :mobile
          end

          should_respond_with :success
          should_render_with_layout :application
          should_assign_to(:community) { @community }
          should_assign_to(:promo) { @active_promo }
        end
      end
    end

    context 'with an apartment community' do
      browser_context do
        setup do
          @community = ApartmentCommunity.make :promo => @active_promo
          get :index, :apartment_community_id => @community.to_param
        end

        should_respond_with :redirect
        should_redirect_to('the home community page') { @community }
      end

      mobile_context do
        context 'with an expired promo' do
          setup do
            @community = ApartmentCommunity.make :promo => @expired_promo
            get :index,
              :apartment_community_id => @community.to_param,
              :format => :mobile
          end

          should_respond_with :redirect
          should_redirect_to('the home community page') { @community }
        end

        context 'with an active promo' do
          setup do
            @community = ApartmentCommunity.make :promo => @active_promo
            get :index,
              :apartment_community_id => @community.to_param,
              :format => :mobile
          end

          should_respond_with :success
          should_render_with_layout :application
          should_assign_to(:community) { @community }
          should_assign_to(:promo) { @active_promo }
        end
      end
    end
  end
end
