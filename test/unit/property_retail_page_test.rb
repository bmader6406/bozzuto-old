require 'test_helper'

class PropertyRetailPageTest < ActiveSupport::TestCase
  context 'PropertyFeaturesPage' do
    should belong_to(:property)
    should belong_to(:apartment_community)
    should belong_to(:home_community)
    should belong_to(:project)

    should have_many(:slides)

    should validate_presence_of(:property_id)

    ['to_s', 'typus_name'].each do |method|
      describe "##{method}" do
        subject do
          property = ApartmentCommunity.make(:title => 'Gotham Heights')
          PropertyRetailPage.make(:property => property)
        end

        it "returns the name of the property followed by 'Retail Page'" do
          subject.public_send(method).should == 'Gotham Heights Retail Page'
        end
      end
    end
  end
end
