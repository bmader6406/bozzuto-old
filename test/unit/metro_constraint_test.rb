require 'test_helper'

class MetroConstraintTest < ActiveSupport::TestCase
  context "A MetroConstraint" do
    before do
      @request = mock('ActionDispatch::Request')

      Metro.make(name: "DC Metro")
    end

    describe ".matches?" do

      context "with an existing metro" do
        it "returns true" do
          @request.stubs(:params).returns({
            id: 'dc-metro'
          })

          MetroConstraint.matches?(@request).should == true
        end
      end

      context "with no exisiting metro" do
        it "returns false" do
          @request.stubs(:params).returns({
            id: 'boston-metro'
          })

          MetroConstraint.matches?(@request).should == false
        end
      end
    end
  end
end
