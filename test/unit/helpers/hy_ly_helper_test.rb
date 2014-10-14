require 'test_helper'

class HyLyHelperTest < ActionView::TestCase
  context "#hyly_script_for" do
    context "when the given community has a Hy.Ly ID" do
      before do
        @community = ApartmentCommunity.new(:hyly_id => '12345')
      end

      should "return the correct HTML" do
        html = hyly_script_for @community

        html.should include "src=\"//app.hy.ly/fjs/#{Bozzuto::HyLy::ID}/0.js?pid=12345"
      end
    end

    context "when the given community does not have a Hy.Ly ID" do
      before do
        @community = ApartmentCommunity.new(:hyly_id => nil)
      end

      should "return the correct HTML" do
        html = hyly_script_for @community

        html.should include "src=\"//app.hy.ly/fjs/#{Bozzuto::HyLy::ID}/0.js\">"
      end
    end
  end

  context "#hyly_form" do
    should "return the correct HTML" do
      html = hyly_form(:redirect_to => 'www.test.com')

      html.should include "hy-#{Bozzuto::HyLy::ID}-0"
      html.should include "data-redirect-url=\"www.test.com\""
    end

    context "when a redirect url is not given" do
      it "raises an error" do
        expect { hyly_form }.to raise_error KeyError
      end
    end
  end
end
