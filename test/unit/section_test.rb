require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  context 'Section' do
    setup do
      @section = Section.make
    end

    subject { @section }

    should_validate_presence_of :title
    should_validate_uniqueness_of :title

    should_have_many :news_posts, :testimonials, :awards, :projects


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

    context '#about?' do
      context "when slug is 'about'" do
        setup do
          @section.update_attributes :title => 'About'
        end

        should 'be true' do
          assert @section.about?
        end
      end

      context "when slug is anything else" do
        setup do
          @section.update_attributes :title => 'Booya'
        end

        should 'be false' do
          assert !@section.about?
        end
      end
    end

    context '#aggregate?' do
      context "when About section" do
        setup do
          @section.update_attributes :title => 'About'
        end

        should 'be true' do
          assert @section.aggregate?
        end
      end

      context "when any other section" do
        setup do
          @section.update_attributes :title => 'Booya'
        end

        should 'be false' do
          assert !@section.aggregate?
        end
      end
    end
  end
end
