require 'test_helper'

# ControllerTest generated by Typus, use it to test the extended admin functionality.
class Admin::UnderConstructionLeadsControllerTest < ActionController::TestCase
  context 'Admin::UnderConstructionLeadsController' do
    setup do
      @user = TypusUser.make
      login_typus_user @user
    end

    context "on GET to :index with :csv format" do
      setup do
        UnderConstructionLead.make(:address => '123 Awesome Ln')

        get :index, :format => 'csv'
      end

      teardown do
        begin
          File.delete(*Dir[Rails.root.join('tmp', 'export-under_construction_leads*.csv')])
        rescue Errno::ENOENT
          nil
        end
      end

      should respond_with(:success)

      should "contain a non-CMS-managed field" do
        @response.body.should =~ /TheID/
      end

      should "contain a CMS-managed field" do
        @response.body.should =~ /123 Awesome Ln/
      end
    end

    context "with existing leads" do
      setup do
        @lead1 = UnderConstructionLead.make
        @lead2 = UnderConstructionLead.make
      end

      context "on POST to :destroy_multiple" do
        setup do
          expect {
            post :destroy_multiple, :ids => [@lead1.id, @lead2.id]
          }.to change { UnderConstructionLead.count }.by(-2)
        end

        should respond_with(:redirect)
      end
    end
  end
end
