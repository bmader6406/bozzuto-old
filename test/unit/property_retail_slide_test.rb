require 'test_helper'

class PropertyRetailSlideTest < ActiveSupport::TestCase
  context 'PropertyRetailSlide' do
    should belong_to(:property_retail_page)

    should have_attached_file(:image)

    should validate_attachment_presence(:image)

    should ensure_length_of(:caption).is_at_least(0).is_at_most(128)

    ['to_s', 'typus_name'].each do |method|
      describe "##{method}" do
        subject { PropertyRetailSlide.make(:name => 'Retail Storefront') }

        it "returns the slide name" do
          subject.public_send(method).should == 'Retail Storefront'
        end
      end
    end
  end
end
