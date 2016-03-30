require 'test_helper'

class MetroAreaNeighbohoodConstraintTest < ActiveSupport::TestCase
  context "A MetroAreaNeighborhoodConstraint" do
    before do
      @request = mock('ActionDispatch::Request')

      metro = Metro.make(name: "DC Metro")
      area  = Area.make(name: "Northwest", metro: metro)
      Neighborhood.make(name: "Glover Park", area: area)
    end

    describe ".matches?" do

      context "with an existing metro, area and neighborhood" do
        it "returns true" do
          @request.stubs(:params).returns({
            metro_id: 'dc-metro',
            area_id:  'northwest',
            id:       'glover-park'
          })

          MetroAreaNeighborhoodConstraint.matches?(@request).should == true
        end
      end

      context "with no exisiting metro, area and neighborhood" do
        it "returns false" do
          @request.stubs(:params).returns({
            metro_id: 'dc-metro',
            area_id:  'southeast',
            id:       'georgetown'
          })

          MetroAreaNeighborhoodConstraint.matches?(@request).should == false
        end
      end
    end
  end
end
