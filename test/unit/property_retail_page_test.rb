require 'test_helper'

class PropertyRetailPageTest < ActiveSupport::TestCase
  context 'PropertyFeaturesPage' do
    should belong_to(:property)

    should have_many(:slides)

    should validate_presence_of(:property)

    describe "#to_s" do
      subject do
        property = ApartmentCommunity.make(title: 'Gotham Heights')
        PropertyRetailPage.make(property: property)
      end

      it "returns the name of the property followed by 'Retail Page'" do
        subject.to_s.should == 'Gotham Heights Retail Page'
      end
    end
  end
end
