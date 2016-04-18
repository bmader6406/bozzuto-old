require 'test_helper'

class PropertyRetailSlideTest < ActiveSupport::TestCase
  context 'PropertyRetailSlide' do
    should belong_to(:property_retail_page)

    should have_attached_file(:image)

    should validate_attachment_presence(:image)

    describe "#to_s" do
      subject { PropertyRetailSlide.make(name: 'Retail Storefront') }

      it "returns the slide name" do
        subject.to_s.should == 'Retail Storefront'
      end
    end
  end
end
