require 'test_helper'

class StateTest < ActiveSupport::TestCase
  context "A State" do
    subject { State.make }

    should_have_many(:cities, :counties)
    should_have_many(:apartment_communities, :through => :cities)
    should_have_many(:home_communities, :through => :cities)
    should_have_many(:communities, :through => :cities)
    should_have_many(:featured_apartment_communities, :through => :cities)
    should_have_many(:neighborhoods)

    should_validate_presence_of(:code, :name)
    should_ensure_length_is(:code, 2)
    should_validate_uniqueness_of(:code, :name)

    describe "#to_param" do
      it "returns the code" do
        assert_equal subject.code, subject.to_param
      end
    end

    describe "#to_s" do
      it "returns the name" do
        assert_equal subject.name, subject.to_s
      end
    end
  end
end
