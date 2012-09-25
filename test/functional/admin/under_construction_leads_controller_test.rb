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
        @output = StringIO.new
        @output.binmode

        get :index, :format => 'csv'

        assert_nothing_raised { @response.body.call(@response, @output) }
      end

      should_respond_with :success

      should "contain a non-CMS-managed field" do
        assert_match /TheID/, @output.string
      end

      should "contain a CMS-managed field" do
        assert_match /123 Awesome Ln/, @output.string
      end
    end
  end
end
