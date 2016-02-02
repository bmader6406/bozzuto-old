require 'test_helper'

class ActiveRecordTipTest < ActiveSupport::TestCase

  context 'ActiveRecord Tip plugin' do
    describe "#human_tip_text" do
      context "a tip translation exists" do
        it "returns the translation" do
          Award.human_tip_text(:image).should == 'Image dimensions should be 150x150'
        end
      end

      context "no tip translation exists" do
        it "returns an empty string" do
          Award.human_tip_text(:title).should == ''
        end
      end
    end
  end
end
