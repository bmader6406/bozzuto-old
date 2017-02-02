require 'test_helper'

class LeaderTest < ActiveSupport::TestCase
  extend AlgoliaSearchable

  context "Leader" do
    it_should_behave_like "being searchable with algolia", Leader, :name

    should have_many(:leaderships).dependent(:destroy)

    should validate_presence_of(:name)
    should validate_presence_of(:title)
    should validate_presence_of(:company)
    should validate_presence_of(:bio)

    describe "#to_s" do
      subject { Leader.new(:name => 'Lucius Fox') }

      it "returns the name" do
        subject.to_s.should == 'Lucius Fox'
      end
    end
  end
end
