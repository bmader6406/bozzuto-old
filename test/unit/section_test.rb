require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  context 'Section' do
    setup do
      @section = Section.make
    end

    subject { @section }

    should_validate_presence_of :title
    should_validate_uniqueness_of :title

    should_have_many :testimonials, :projects
    should_have_and_belong_to_many :awards, :news_posts, :press_releases

    should_have_attached_file :left_montage_image
    should_have_attached_file :middle_montage_image
    should_have_attached_file :right_montage_image


    context '#typus_name' do
      should 'return the title' do
        assert_equal @section.title, @section.typus_name
      end
    end

    context 'self#about' do
      setup do
        @section = Section.make(:about)
      end

      should 'return the About section' do
        assert_equal @section, Section.about
      end
    end

    context 'self#news_and_press' do
      setup do
        @section = Section.make(:news_and_press)
      end

      should 'return the News & Press section' do
        assert_equal @section, Section.news_and_press
      end
    end

    context '#about?' do
      context "when about flag is true" do
        setup { @section.about = true }

        should 'return true' do
          assert @section.about?
        end
      end

      context "when slug is anything else" do
        setup { @section.about = false }

        should 'return false false' do
          assert !@section.about?
        end
      end
    end

    context '#aggregate?' do
      context "when About section" do
        setup { @section.about = true }

        should 'return true' do
          assert @section.aggregate?
        end
      end

      context "when any other section" do
        setup { @section.about = false }

        should 'return false' do
          assert !@section.aggregate?
        end
      end
    end

    context '#montage?' do
      context 'when all montage images are present' do
        setup do
          @section.expects(:left_montage_image?).returns(true)
          @section.expects(:middle_montage_image?).returns(true)
          @section.expects(:right_montage_image?).returns(true)
        end

        should 'return true' do
          assert @section.montage?
        end
      end

      context 'when any montage images are missing' do
        setup do
          @section.expects(:left_montage_image?).returns(false)
          @section.stubs(:middle_montage_image?).returns(true)
          @section.stubs(:right_montage_image?).returns(true)
        end

        should 'return true' do
          assert !@section.montage?
        end
      end
    end
  end
end
