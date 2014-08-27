require 'test_helper'

class RedirectRulesTest < ActiveSupport::TestCase
  context "RedirectRules" do
    describe ".each" do
      it "yields each rule's components" do
        components = [].tap do |components|
          RedirectRules.each { |rule| components << rule }
        end

        assert_equal components.size, RedirectRules.list.size
      end
    end

    describe ".list" do
      it "returns an array of redirect rules" do
        all_rules = RedirectRules.list.all? do |rule|
          rule.respond_to?(:url_regex) &&
          rule.respond_to?(:redirect_url) &&
          rule.respond_to?(:condition) &&
          rule.respond_to?(:components)
        end

        assert all_rules
      end
    end
  end
end
