require 'test_helper'

class PropertyContactPageTest < ActiveSupport::TestCase
  context 'PropertyContactPage' do
    before do
      @property = ApartmentCommunity.make(title: 'Boomtown Suites')
    end

    subject do
      PropertyContactPage.create(property: @property)
    end

    should belong_to(:property)

    should validate_presence_of(:property)

    describe "#to_s" do
      it "returns the page type and the page's property" do
        subject.to_s.should == 'Property Contact Page for Boomtown Suites'
      end
    end

    describe "#apartment_community" do
      it "returns the property if it's an Apartment Community" do
        subject.apartment_community == @property
      end

      it "returns nil when it isn't a Home Community" do
        subject.apartment_community == nil
      end
    end

    describe "#home_community" do
      before do
        @home = HomeCommunity.make(title: 'Boomtown Mansion')
      end

      subject do
        PropertyContactPage.create(property: @home)
      end

      it "returns the property if it's an Home Community" do
        subject.home_community == @home
      end

      it "returns nil when it isn't a Home Community" do
        subject.home_community == nil
      end
    end
  end
end
