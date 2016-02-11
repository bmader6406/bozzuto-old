require 'test_helper'

class RedirectRulesTest < ActiveSupport::TestCase
  context "RedirectRules" do

    describe ".list" do
      it "returns an array of redirect rules" do
        RedirectRules.list.all? { |rule| rule.is_a? RedirectRules::Rule }.should == true
      end
    end

    describe "inspecting a redirect rule's methods" do
      setup do
        @subject = RedirectRules::Rule.new('regex', 'url', 'condition')
      end

      describe "#url_regex" do
        it "returns the url regex" do
          @subject.url_regex.should == 'regex'
        end
      end

      describe "#redirect_url" do
        it "returns the redirect url" do
          @subject.redirect_url.should == 'url'
        end
      end

      describe "#condition" do
        it "returns the condition" do
          @subject.condition.should == 'condition'
        end
      end

      describe "#to_a" do
        context "when condition is present" do
          it "returns an array containing the url regex, redirect url, and condition" do
            @subject.to_a.should == ['regex', 'url', 'condition']
          end
        end

        context "when condition is not present" do
          it "returns an array containing the url regex and redirect url" do
            @subject.condition = nil
            @subject.to_a.should == ['regex', 'url']
          end
        end
      end
    end
  end
end
