require 'test_helper'

class PromosControllerTest < ActionController::TestCase
  context 'a GET to #index' do
    setup do
      @active_promo  = Promo.make :active
      @expired_promo = Promo.make :expired
    end

    context 'with a home community' do
      desktop_device do
        setup do
          @community = HomeCommunity.make :promo => @active_promo

          get :index, :home_community_id => @community.to_param
        end

        should respond_with(:redirect)
        should redirect_to('the home community page') { @community }
      end

      mobile_device do
        context 'with an expired promo' do
          setup do
            @community = HomeCommunity.make :promo => @expired_promo

            get :index, :home_community_id => @community.to_param
          end

          should respond_with(:redirect)
          should redirect_to('the home community page') { @community }
        end

        context 'with an active promo' do
          setup do
            @community = HomeCommunity.make :promo => @active_promo

            get :index, :home_community_id => @community.to_param
          end

          should respond_with(:success)
          should render_with_layout(:application)
          should assign_to(:community) { @community }
          should assign_to(:promo) { @active_promo }
        end
      end
    end

    context 'with an apartment community' do
      desktop_device do
        setup do
          @community = ApartmentCommunity.make :promo => @active_promo
          get :index, :apartment_community_id => @community.to_param
        end

        should respond_with(:redirect)
        should redirect_to('the home community page') { @community }
      end

      mobile_device do
        context 'with an expired promo' do
          setup do
            @community = ApartmentCommunity.make :promo => @expired_promo

            get :index, :apartment_community_id => @community.to_param
          end

          should respond_with(:redirect)
          should redirect_to('the home community page') { @community }
        end

        context 'with an active promo' do
          setup do
            @community = ApartmentCommunity.make :promo => @active_promo

            get :index, :apartment_community_id => @community.to_param
          end

          should respond_with(:success)
          should render_with_layout(:application)
          should assign_to(:community) { @community }
          should assign_to(:promo) { @active_promo }
        end
      end
    end
  end
end
