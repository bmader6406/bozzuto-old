require 'test_helper'

class PropertyFeatureTest < ActiveSupport::TestCase
  context 'PropertyFeature' do
    subject { PropertyFeature.make }

    should have_many(:property_feature_attributions)
    should have_many(:apartment_communities).through(:property_feature_attributions)
    should have_many(:home_communities).through(:property_feature_attributions)

    should have_attached_file(:icon)

    should validate_uniqueness_of(:name)

    describe "#to_s" do
      subject { PropertyFeature.new(name: 'Bat Cave') }

      it "returns the name" do
        subject.to_s.should == 'Bat Cave'
      end
    end
  end
end
