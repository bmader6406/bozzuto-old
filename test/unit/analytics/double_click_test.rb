require 'test_helper'

module Analytics
  class DoubleClickTest < ActiveSupport::TestCase
    context "DoubleClick" do
      context "#floodlight_tag_script" do
        setup do
          @options = {
            :name        => 'Test Property',
            :type        => 'conve135',
            :cat         => 'conta168',
            :description => 'such tag'
          }
        end

        it "returns the correct script" do
          script = Analytics::DoubleClick.new(@options).floodlight_tag_script

          assert_match /type=conve135/, script
          assert_match /cat=conta168/, script
          assert_match /u1=Test%20Property/, script
          assert_match /such tag/, script
          assert_match /ord='\+ a \+ '\?/, script
        end

        context "when initialized with fixed order set to true" do
          it "returns the correct script" do
            script = Analytics::DoubleClick.new(@options.merge(:fixed_ord => true)).floodlight_tag_script

            assert_match /type=conve135/, script
            assert_match /cat=conta168/, script
            assert_match /u1=Test%20Property/, script
            assert_match /such tag/, script
            assert_match /ord=1;num='\+ a \+ '\?/, script
          end
        end

        context "when initialized with image set to true" do
          it "returns the correct script" do
            script = Analytics::DoubleClick.new(@options.merge(:image => true)).floodlight_tag_script

            assert_match /type=conve135/, script
            assert_match /cat=conta168/, script
            assert_match /u1=Test%20Property/, script
            assert_match /such tag/, script
            assert_match /img/, script
            assert_match /alt=\"\"\/>/, script
          end
        end
      end
    end
  end
end
