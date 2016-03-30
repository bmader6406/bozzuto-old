require 'test_helper'

class MetroAreaConstraintTest < ActiveSupport::TestCase
  context "A MetroAreaConstraint" do
    before do
      @request = mock('ActionDispatch::Request')

      metro = Metro.make(name: "DC Metro")
      Area.make(name: "Northwest", metro: metro)
    end

    describe ".matches?" do

      context "with an existing metro and area" do
        it "returns true" do
          @request.stubs(:params).returns({
            metro_id: 'dc-metro',
            id:       'northwest'
          })

          MetroAreaConstraint.matches?(@request).should == true
        end
      end

      context "with no exisiting metro and area" do
        it "returns false" do
          @request.stubs(:params).returns({
            metro_id: 'dc-metro',
            id:       'southeast'
          })

          MetroAreaConstraint.matches?(@request).should == false
        end
      end
    end
  end
end
