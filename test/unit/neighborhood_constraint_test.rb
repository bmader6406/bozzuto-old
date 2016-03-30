require 'test_helper'

class NeighbohoodConstraintTest < ActiveSupport::TestCase
  context "A MetroAreaNeighborhoodConstraint" do
    before do
      @request = mock('ActionDispatch::Request')

      Neighborhood.make(name: "Glover Park")
    end

    describe ".matches?" do

      context "with an existing neighborhood" do
        it "returns true" do
          @request.stubs(:params).returns({
            id: 'glover-park'
          })

          NeighborhoodConstraint.matches?(@request).should == true
        end
      end

      context "with no exisiting neighborhood" do
        it "returns false" do
          @request.stubs(:params).returns({
            id: 'georgetown'
          })

          NeighborhoodConstraint.matches?(@request).should == false
        end
      end
    end
  end
end
