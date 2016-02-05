require 'test_helper'

class LassoHelperTest < ActionView::TestCase
  context 'LassoHelper' do
    setup do
      @community = HomeCommunity.make
      @lasso     = LassoAccount.make(:property => @community)
    end

    context '#lasso_tracking_js' do
      should 'return the tracking code' do
        js = lasso_tracking_js(@community)
        assert_match /var tracker = new LassoAnalytics\(#{@lasso.analytics_id.inspect}\);/, js
      end
    end

    context '#lasso_hidden_fields' do
      context 'when analytics_id is blank' do
        setup do
          @lasso.analytics_id = nil
          @lasso.save

          @html = Nokogiri::HTML(lasso_hidden_fields(@community))
        end

        should 'return the input tags' do
          {
            'LassoUID'           => @lasso.uid,
            'ClientID'           => @lasso.client_id,
            'ProjectID'          => @lasso.project_id,
            'SignupThankyouLink' => thank_you_home_community_contact_url(@community)
          }.each do |name, value|
            @html.at("input[@name=#{name}]/@value").try(:value).should == value
          end
        end

        should 'not have the analytics fields' do
          ['domainAccountId', 'guid'].each do |name|
            @html.at("input[@name=#{name}]/@value").try(:value).should eq nil
          end
        end
      end

      context 'when analytics_id is present' do
        setup do
          @html = Nokogiri::HTML(lasso_hidden_fields(@community))
        end

        should 'return the input tags' do
          {
            'LassoUID'           => @lasso.uid,
            'ClientID'           => @lasso.client_id,
            'ProjectID'          => @lasso.project_id,
            'SignupThankyouLink' => thank_you_home_community_contact_url(@community),
            'domainAccountId'    => @lasso.analytics_id,
            'guid'               => nil
          }.each do |name, value|
            @html.at("input[@name=#{name}]/@value").try(:value).should == value
          end
        end
      end
    end

    describe "#secondary_lead_source" do
      setup do
        @community.update_attributes(:secondary_lead_source_id => '12345')
        @html = Nokogiri::HTML(secondary_lead_source(@community))
      end

      it "returns a hidden input tag with the appropriate information" do
        @html.at("input[@name='12345']/@value").try(:value).should == 'www.bozzuto.com'
      end
    end

    context '#lasso_contact_js' do
      should 'return the contact code' do
        js = lasso_contact_js(@community)
        assert_match /<script type="text\/javascript">/, js
        assert_match /document\.getElementById\('lasso-form'\)/, js
      end
    end
  end
end
