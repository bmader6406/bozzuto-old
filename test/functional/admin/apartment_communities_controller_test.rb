require 'test_helper'

# ControllerTest generated by Typus, use it to test the extended admin functionality.
class Admin::ApartmentCommunitiesControllerTest < ActionController::TestCase
  context 'Admin::ApartmentCommunitiesController' do
    setup do
      @user = TypusUser.make
      login_typus_user @user
      @community1 = ApartmentCommunity.make
      @community2 = ApartmentCommunity.make
      @community1.destroy
    end
    
=begin
    context 'GET to #list_deleted' do
      setup do
        get :list_deleted
      end
      
      should respond_with(:success)
      should render_template(:list_deleted)
      should assign_to(:items)
    end
=end

    types = Bozzuto::ExternalFeed::Feed.feed_types

    context 'GET to #merge' do
      types.each do |type|
        context "with a #{type} community" do
          setup do
            @community = ApartmentCommunity.make(type.to_sym)
            get :merge, :id => @community.id
          end

          should respond_with(:redirect)
          should redirect_to('the edit page') { "/admin/apartment_communities/edit/#{@community.id}" }
          should assign_to(:item) { @community }
        end
      end

      context 'with a non-externally managed community' do
        setup do
          @community = ApartmentCommunity.make
          get :merge, :id => @community.id
        end

        should respond_with(:success)
        should assign_to(:item) { @community }
      end
    end

    context 'GET to #begin_merge' do
      types.each do |type|
        context "with a #{type} community" do
          setup do
            @community = ApartmentCommunity.make(type.to_sym)
            get :begin_merge, :id => @community.id
          end

          should respond_with(:redirect)
          should redirect_to('the edit page') { "/admin/apartment_communities/edit/#{@community.id}" }
          should assign_to(:item) { @community }
          should set_flash.to('This community is already managed externally')
        end
      end

      context 'with a non-externally managed community' do
        setup { @community = ApartmentCommunity.make }

        context 'and with no externally-managed community selected' do
          setup do
            get :begin_merge, :id => @community.id
          end

          should respond_with(:redirect)
          should redirect_to('the merge page') { "/admin/apartment_communities/merge/#{@community.id}" }
          should assign_to(:item) { @community }
          should set_flash.to('You must select an externally-managed community.')
        end

        context 'and community selected that is not externally-managed' do
          setup do
            @other = ApartmentCommunity.make

            get :begin_merge, :id => @community.id, :external_community_id => @other.id
          end

          should respond_with(:redirect)
          should redirect_to('the merge page') { "/admin/apartment_communities/merge/#{@community.id}" }
          should assign_to(:item) { @community }
          should set_flash.to("Couldn't find that externally-managed community.")
        end

        types.each do |type|
          context "with a #{type} community" do
            setup do
              @other = ApartmentCommunity.make(type.to_sym)

              get :begin_merge, :id => @community.id, :external_community_id => @other.id
            end

            should respond_with(:success)
            should assign_to(:item) { @community }
            should assign_to(:external_community) { @other }
          end
        end
      end
    end

    context 'POST to #end_merge' do
      types.each do |type|
        context "with a #{type} community" do
          setup do
            @community = ApartmentCommunity.make(type.to_sym)
            post :end_merge, :id => @community.id
          end

          should respond_with(:redirect)
          should redirect_to('the edit page') { "/admin/apartment_communities/edit/#{@community.id}" }
          should assign_to(:item) { @community }
          should set_flash.to('This community is already managed externally')
        end
      end

      context 'with a local community' do
        setup { @community = ApartmentCommunity.make }

        context 'and with no externally-managed community selected' do
          setup do
            post :end_merge, :id => @community.id
          end

          should respond_with(:redirect)
          should redirect_to('the merge page') { "/admin/apartment_communities/merge/#{@community.id}" }
          should assign_to(:item) { @community }
          should set_flash.to('You must select an externally-managed community.')
        end

        context 'and community selected that is not externally-managed' do
          setup do
            @other = ApartmentCommunity.make

            post :end_merge, :id => @community.id, :external_community_id => @other.id
          end

          should respond_with(:redirect)
          should redirect_to('the merge page') { "/admin/apartment_communities/merge/#{@community.id}" }
          should assign_to(:item) { @community }
          should set_flash.to("Couldn't find that externally-managed community.")
        end

        types.each do |type|
          context "with a #{type} community selected" do
            setup do
              @other = ApartmentCommunity.make(type.to_sym)

              ApartmentCommunity.any_instance.expects(:merge).with(@other).once

              post :end_merge, :id => @community.id, :external_community_id => @other.id
            end

            should respond_with(:redirect)
            should redirect_to('the edit page') { "/admin/apartment_communities/edit/#{@community.id}" }
            should assign_to(:item) { @community }
            should assign_to(:external_community) { @other }
            should set_flash.to('Successfully merged communities')
          end
        end
      end
    end

    context 'GET to #export_field_audit' do
      setup do
        get :export_field_audit
      end

      should respond_with(:success)
      should respond_with_content_type('text/csv')

      should 'respond with the correct Content-Disposition header' do
        assert_equal 'attachment; filename="apartment_communities_field_audit.csv"',
          @response.headers["Content-Disposition"]
      end
    end

    context 'GET to #export_dnr' do
      setup do
        ApartmentCommunity.make(:title => 'Bat-Cave')
        ApartmentCommunity.make(:unpublished, :title => 'Arkham Asylum')

        get :export_dnr
      end

      teardown do
        begin
          File.delete(*Dir[Rails.root.join('tmp', 'export-dnr*.csv')])
        rescue Errno::ENOENT
          nil
        end
      end

      should respond_with(:success)

      it "contains only the published communities" do
        @response.body.should =~ /Bat-Cave/
        @response.body.should_not =~ /Arkham Asylum/
      end
    end

    context "GET to #disconnect" do
      setup do
        @community = ApartmentCommunity.make(:vaultware)
        get :disconnect, :id => @community.id
      end

      should respond_with(:redirect)
      should redirect_to('the edit page') { "/admin/apartment_communities/edit/#{@community.id}" }
      should assign_to(:item) { @community }
      should set_flash.to('Successfully disconnected from Vaultware')

      it "disconnects the feed" do
        @community.reload

        assert !@community.managed_externally?
      end
    end

    context "GET to #delete_floor_plans" do
      setup do
        @community = ApartmentCommunity.make
        @studio    = ApartmentFloorPlanGroup.make(:studio)
        @penthouse = ApartmentFloorPlanGroup.make(:penthouse)
        @plan1     = ApartmentFloorPlan.make(:apartment_community => @community, :floor_plan_group => @studio)
        @plan2     = ApartmentFloorPlan.make(:apartment_community => @community, :floor_plan_group => @penthouse)

        get :delete_floor_plans, :id => @community.id
      end

      should respond_with(:redirect)
      should redirect_to('the edit page') { "/admin/apartment_communities/edit/#{@community.id}" }
      should assign_to(:item) { @community }
      should set_flash.to('Deleted all floor plans.')

      it "deletes all the floor plans for the community" do
        @community.reload

        @community.floor_plans.should == []
      end
    end
  end
end
