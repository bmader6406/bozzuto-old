require 'test_helper'

class MastheadSlideTest < ActiveSupport::TestCase
  context 'MastheadSlide' do
    setup do
      @slide = MastheadSlide.new
    end

    should belong_to(:masthead_slideshow)
    should belong_to(:mini_slideshow)

    should validate_presence_of(:body)


    describe "#typus_name" do
      subject do
        MastheadSlide.new(
          :masthead_slideshow => MastheadSlideshow.new(:name => 'Slideshow'),
          :position           => 2
        )
      end

      it "returns the slideshow name and slide position" do
        subject.typus_name.should == 'Slideshow - Slide #2'
      end
    end

    context '#uses_image?' do
      context 'when slide_type is USE_IMAGE' do
        should 'return true' do
          @slide.slide_type = MastheadSlide::USE_IMAGE
          assert @slide.uses_image?
        end
      end

      context 'when image_type is not USE_IMAGE' do
        should 'return false' do
          @slide.slide_type = MastheadSlide::USE_TEXT
          assert !@slide.uses_image?
        end
      end
    end

    context '#uses_text?' do
      context 'when slide_type is USE_TEXT' do
        should 'return true' do
          @slide.slide_type = MastheadSlide::USE_TEXT
          assert @slide.uses_text?
        end
      end

      context 'when slide_type is not USE_TEXT' do
        should 'return false' do
          @slide.slide_type = MastheadSlide::USE_IMAGE
          assert !@slide.uses_text?
        end
      end
    end

    context '#uses_mini_slideshow?' do
      context 'when slide_type is USE_MINI_SLIDESHOW' do
        should 'return true' do
          @slide.slide_type = MastheadSlide::USE_MINI_SLIDESHOW
          assert @slide.uses_mini_slideshow?
        end
      end

      context 'when slide_type is not USE_PROPERTY' do
        should 'return false' do
          @slide.slide_type = MastheadSlide::USE_IMAGE
          assert !@slide.uses_mini_slideshow?
        end
      end
    end

    context '#uses_quote?' do
      context 'when slide_type is USE_QUOTE' do
        should 'return true' do
          @slide.slide_type = MastheadSlide::USE_QUOTE
          assert @slide.uses_quote?
        end
      end

      context 'when slide_type is not USE_QUOTE' do
        should 'return false' do
          @slide.slide_type = MastheadSlide::USE_IMAGE
          assert !@slide.uses_quote?
        end
      end
    end
  end
end
