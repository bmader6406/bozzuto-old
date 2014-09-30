require 'test_helper'

class PropertyFeatureTest < ActiveSupport::TestCase
  context 'PropertyFeature' do
    subject { PropertyFeature.make }

    should have_and_belong_to_many(:properties)
    should have_and_belong_to_many(:apartment_communities)
    should have_and_belong_to_many(:home_communities)

    should have_attached_file(:icon)

    should validate_uniqueness_of(:name)

    describe "#typus_name" do
      subject { PropertyFeature.new(:name => 'Bat Cave') }

      it "returns the name" do
        subject.typus_name.should == 'Bat Cave'
      end
    end
  end
end
