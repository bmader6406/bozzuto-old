require 'test_helper'

class CarouselPanelTest < ActiveSupport::TestCase
  context 'A carousel panel' do
    subject { CarouselPanel.new }

    should belong_to(:carousel)

    should have_attached_file(:image)
    should validate_presence_of(:link_url)
    should validate_presence_of(:carousel)

    describe "validations" do
      context "when caption is set" do
        before do
          subject.caption = 'yay'
        end

        should validate_presence_of(:heading)
      end

      context "when heading is set" do
        before do
          subject.heading = 'yay'
        end

        should validate_presence_of(:caption)
      end
    end

    describe "#typus_name" do
      before do
        subject.carousel = Carousel.new(:name => 'CAROUSEL')
        subject.position = 4
      end

      it "returns the carousel name and the position" do
        subject.typus_name.should == 'CAROUSEL - Panel #4'
      end
    end
  end
end
