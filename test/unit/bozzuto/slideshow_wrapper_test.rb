require 'test_helper'

class SlideshowWrapperTest < ActiveSupport::TestCase
  context 'SlideshowWrapper' do
    before do
      @page   = Page.make
      @record = Carousel.make(content: @page, name: 'Oh Dear')
    end

    subject { Bozzuto::SlideshowWrapper.new(:carousel, @page) }

    describe "#name" do
      it "returns the name of the underlying slideshow record" do
        subject.name.should == 'Oh Dear'
      end
    end

    describe "#present?" do
      context "when a record of the given slideshow type exists for the given page" do
        it "returns true" do
          subject.present?.should == true
        end
      end

      context "when a record for the given slideshow type is missing for the given page" do
        before do
          @missing = Bozzuto::SlideshowWrapper.new(:masthead_slideshow, @page)
        end

        it "returns false" do
          @missing.present?.should == false
        end
      end
    end

    describe "#label" do
      it "returns a titleized version of the slideshow type" do
        subject.label.should == 'Carousel'
      end
    end

    describe "#url_params" do
      it "returns the show URL params by default" do
        subject.url_params.should == [:new_admin, @record]
      end

      context "when provided the new action" do
        it "returns the appropriate URL params for the new action" do
          subject.url_params(:new).should == [:new, :new_admin, :carousel, carousel: { page_id: @page.id }] 
        end
      end
    end
  end
end
