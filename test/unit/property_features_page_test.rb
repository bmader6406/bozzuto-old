require 'test_helper'

class PropertyFeaturesPageTest < ActiveSupport::TestCase
  context 'PropertyFeaturesPage' do
    should belong_to(:property)
    should belong_to(:apartment_community)
    should belong_to(:home_community)
    should belong_to(:project)

    should validate_presence_of(:property_id)

    describe "#features" do
      context "when the page has no features" do
        subject do
          PropertyFeaturesPage.make(
            :title_1  => nil,
            :text_1   => nil,
            :title_2  => nil,
            :text_2   => nil,
            :title_3  => nil,
            :text_3   => nil
          )
        end

        it "returns an empty array" do
          subject.features.should == []
        end
      end

      context "when the page has features" do
        subject do
          PropertyFeaturesPage.make(
            :title_1  => 'One Face',
            :text_1   => 'has one face',
            :title_2  => 'Two Face',
            :text_2   => 'has two faces',
            :title_3  => 'Red Face',
            :text_3   => 'has red face'
          )
        end

        it "contains the appropriate features" do
          subject.features[0].title.should == 'One Face'
          subject.features[0].text.should == 'has one face'
          subject.features[1].title.should == 'Two Face'
          subject.features[1].text.should == 'has two faces'
          subject.features[2].title.should == 'Red Face'
          subject.features[2].text.should == 'has red face'
        end
      end
    end
  end
end
