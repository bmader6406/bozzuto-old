require 'test_helper'

class TestimonialTest < ActiveSupport::TestCase
  context 'Testimonial' do

    should belong_to(:section)

    should validate_presence_of(:quote)

    describe "#excerpt" do
      it "returns nil" do
        Testimonial.new(quote: nil).excerpt.should == nil
      end

      it "strips tags" do
        subject = Testimonial.new(quote: "<p>Haaay</p>")

        subject.excerpt.should == "Haaay"
      end

      it "limits the excerpt to 100 by default" do
        quote   = "a" * 150
        subject = Testimonial.new(quote: quote)

        subject.excerpt.length.should == 100
      end

      it "limits the excerpt" do
        quote   = "a" * 150
        subject = Testimonial.new(quote: quote)

        subject.excerpt(30).length.should == 30
      end
    end
  end
end
