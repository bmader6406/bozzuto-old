require 'test_helper'

class MastheadSlideTest < ActiveSupport::TestCase
  context 'MastheadSlide' do
    setup do
      @slide = MastheadSlide.new
    end

    should_belong_to :masthead_slideshow
    should_belong_to :featured_property
    should_belong_to :featured_apartment_community
    should_belong_to :featured_home_community
    should_belong_to :featured_project

    should_validate_presence_of :body


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

    context '#uses_featured_property?' do
      context 'when slide_type is USE_PROPERTY' do
        should 'return true' do
          @slide.slide_type = MastheadSlide::USE_PROPERTY
          assert @slide.uses_featured_property?
        end
      end

      context 'when slide_type is not USE_PROPERTY' do
        should 'return false' do
          @slide.slide_type = MastheadSlide::USE_IMAGE
          assert !@slide.uses_featured_property?
        end
      end
    end
  end
end
