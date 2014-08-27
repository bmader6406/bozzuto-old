require 'test_helper'

class RedirectRulesTest < ActiveSupport::TestCase
  context "RedirectRules" do
    describe ".list" do
      it "returns an array of redirect rules" do
        all_rules = RedirectRules.list.all? do |rule|
          rule.is_a? RedirectRules::Rule
        end

        assert all_rules
      end
    end

    describe "inspecting a redirect rule's methods" do
      setup do
        @subject = RedirectRules::Rule.new('regex', 'url', 'condition')
      end

      describe "#url_regex" do
        it "returns the url regex" do
          assert_equal @subject.url_regex, 'regex'
        end
      end

      describe "#redirect_url" do
        it "returns the redirect url" do
          assert_equal @subject.redirect_url, 'url'
        end
      end

      describe "#condition" do
        it "returns the condition" do
          assert_equal @subject.condition, 'condition'
        end
      end

      describe "#to_a" do
        context "when condition is present" do
          it "returns an array containing the url regex, redirect url, and condition" do
            assert_equal @subject.to_a, ['regex', 'url', 'condition']
          end
        end

        context "when condition is not present" do
          it "returns an array containing the url regex and redirect url" do
            @subject.condition = nil

            assert_equal @subject.to_a, ['regex', 'url']
          end
        end
      end
    end
  end
end
