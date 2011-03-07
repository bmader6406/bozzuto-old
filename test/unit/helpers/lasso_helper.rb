require 'test_helper'

class LassoHelperTest < ActionView::TestCase
  context 'LassoHelper' do
    setup do
      @community = HomeCommunity.make
      @lasso     = LassoAccount.make(:property => @community)
    end

    context '#lasso_hidden_fields' do
      context 'when analytics_id is blank' do
        setup do
          @lasso.analytics_id = nil
          @lasso.save

          @html = HTML::Document.new(lasso_hidden_fields(@community))
        end

        should 'return the input tags' do
          {
            'LassoUID'           => @lasso.uid,
            'ClientID'           => @lasso.client_id,
            'ProjectID'          => @lasso.project_id,
            'SignupThankyouLink' => thank_you_home_community_lasso_submissions_url(@community)
          }.each do |name, value|
            assert_select @html.root, "input[name=#{name}]", :value => value
          end
        end

        should 'not have the analytics fields' do
          ['domainAccountId', 'guid'].each do |name|
            selector = HTML::Selector.new("input[name=#{name}]")
            assert selector.select(@html.root).empty?
          end
        end
      end

      context 'when analytics_id is present' do
        setup do
          @html = HTML::Document.new(lasso_hidden_fields(@community))
        end

        should 'return the input tags' do
          {
            'LassoUID'           => @lasso.uid,
            'ClientID'           => @lasso.client_id,
            'ProjectID'          => @lasso.project_id,
            'SignupThankyouLink' => thank_you_home_community_lasso_submissions_url(@community),
            'domainAccountId'    => @lasso.analytics_id,
            'guid'               => ''
          }.each do |name, value|
            assert_select @html.root, "input[name=#{name}]", :value => value
          end
        end
      end
    end
  end
end
