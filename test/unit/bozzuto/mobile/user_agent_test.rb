require 'test_helper'

module Bozzuto::Mobile
  class UserAgentTest < ActiveSupport::TestCase
    context "UserAgent" do
      context "string is for mobile browser" do
        subject { UserAgent.new('iPhone') }

        context "#mobile?" do
          should "return true" do
            assert subject.mobile?
          end
        end

        context "#device" do
          should "return the correct device" do
            assert_equal :iphone, subject.device
          end
        end
      end

      context "string is for desktop browser" do
        subject { UserAgent.new('Safari') }

        context "#mobile?" do
          should "return false" do
            assert !subject.mobile?
          end
        end

        context "#device" do
          should "return the correct device" do
            assert_equal :browser, subject.device
          end
        end
      end
    end
  end
end
