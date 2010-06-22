require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  context 'Section' do
    setup do
      @section = Section.make
    end

    subject { @section }

    should_validate_presence_of :title
    should_validate_uniqueness_of :title

    should_have_many :news_posts, :testimonials


    context '#typus_name' do
      should 'return the title' do
        assert_equal @section.title, @section.typus_name
      end
    end

    context '#aggregate?' do
      context "when slug is 'about'" do
        setup do
          @section.update_attributes :title => 'About'
        end

        should 'be true' do
          assert @section.aggregate?
        end
      end

      context "when slug is anything else" do
        setup do
          @section.update_attributes :title => 'Booya'
        end

        should 'be false' do
          assert !@section.aggregate?
        end
      end
    end

    context 'when quering news posts' do
      setup do
        2.times { NewsPost.make :section => @section }
        2.times { NewsPost.make :section => Section.make }
      end

      context 'and in the about section' do
        setup do
          @section = Section.make :title => 'About'
        end

        should 'return all news posts' do
          assert_equal NewsPost.all, @section.news_posts
        end
      end

      context 'and not in the about section' do
        should "return this section's news posts" do
          @news_posts = NewsPost.find_all_by_section_id(@section.id)
          assert_equal @news_posts, @section.news_posts
        end
      end
    end

    context 'when quering testimonials' do
      setup do
        2.times { Testimonial.make :section => @section }
        2.times { Testimonial.make :section => Section.make }
      end

      context 'and in the about section' do
        setup do
          @section = Section.make :title => 'About'
        end

        should 'return all testimonials' do
          assert_equal Testimonial.all, @section.testimonials
        end
      end

      context 'and not in the about section' do
        should "return this section's testimonials" do
          @testimonials = Testimonial.find_all_by_section_id(@section.id)
          assert_equal @testimonials, @section.testimonials
        end
      end
    end
  end
end
