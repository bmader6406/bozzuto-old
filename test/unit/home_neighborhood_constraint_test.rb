require 'test_helper'

class HomeNeighbohoodConstraintTest < ActiveSupport::TestCase
  context "A HomeNeighborhoodConstraint" do
    before do
      @request = mock('ActionDispatch::Request')

      HomeNeighborhood.make(name: "Glover Park")
    end

    describe ".matches?" do

      context "with an existing home neighborhood" do
        it "returns true" do
          @request.stubs(:params).returns({
            id: 'glover-park'
          })

          HomeNeighborhoodConstraint.matches?(@request).should == true
        end
      end

      context "with no exisiting home neighborhood" do
        it "returns false" do
          @request.stubs(:params).returns({
            id: 'georgetown'
          })

          HomeNeighborhoodConstraint.matches?(@request).should == false
        end
      end
    end
  end
end
