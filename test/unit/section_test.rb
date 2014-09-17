require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  context 'Section' do
    subject { Section.make }

    should validate_presence_of(:title)
    should validate_uniqueness_of(:title)

    should have_many(:testimonials)
    should have_many(:projects)
    should have_and_belong_to_many(:awards)
    should have_and_belong_to_many(:news_posts)
    should have_and_belong_to_many(:press_releases)
    should have_one(:contact_topic)

    should have_attached_file(:left_montage_image)
    should have_attached_file(:middle_montage_image)
    should have_attached_file(:right_montage_image)


    context '#typus_name' do
      should 'return the title' do
        assert_equal subject.title, subject.typus_name
      end
    end

    context 'self#about' do
      subject { Section.make(:about) }

      should 'return the About section' do
        assert_equal subject, Section.about
      end
    end

    context 'self#news_and_press' do
      subject { Section.make(:news_and_press) }

      should 'return the News & Press section' do
        assert_equal subject, Section.news_and_press
      end
    end

    context '#about?' do
      context "when about flag is true" do
        setup { subject.about = true }

        should 'return true' do
          assert subject.about?
        end
      end

      context "when slug is anything else" do
        setup { subject.about = false }

        should 'return false false' do
          assert !subject.about?
        end
      end
    end

    context '#aggregate?' do
      context "when About section" do
        setup { subject.about = true }

        should 'return true' do
          assert subject.aggregate?
        end
      end

      context "when any other section" do
        setup { subject.about = false }

        should 'return false' do
          assert !subject.aggregate?
        end
      end
    end

    context '#montage?' do
      context 'when all montage images are present' do
        setup do
          subject.expects(:left_montage_image?).returns(true)
          subject.expects(:middle_montage_image?).returns(true)
          subject.expects(:right_montage_image?).returns(true)
        end

        should 'return true' do
          assert subject.montage?
        end
      end

      context 'when any montage images are missing' do
        setup do
          subject.expects(:left_montage_image?).returns(false)
          subject.stubs(:middle_montage_image?).returns(true)
          subject.stubs(:right_montage_image?).returns(true)
        end

        should 'return true' do
          assert !subject.montage?
        end
      end
    end
  end
end
