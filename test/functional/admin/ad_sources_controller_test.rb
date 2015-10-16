require 'test_helper'

class Admin::AdSourcesControllerTest < ActionController::TestCase
  context 'Admin::AdSourcesController' do
    setup do
      @user = TypusUser.make
      login_typus_user @user
    end

    context "on GET to :index with :csv format" do
      setup do
        AdSource.make(:domain_name => 'bozzuto.com', :value => 'BOZZUTO')

        get :index, :format => 'csv'
      end

      teardown do
        begin
          File.delete(*Dir[Rails.root.join('tmp', 'export-ad_sources*.csv')])
        rescue Errno::ENOENT
          nil
        end
      end

      should respond_with(:success)

      should "contain the exported CSV" do
        @response.body.should =~ /bozzuto\.com,BOZZUTO/
      end
    end
  end
end
