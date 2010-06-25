require 'test_helper'

class SectionContentControllerTest < ActionController::TestCase
  context 'SectionContentController' do
    setup do
      @section = Section.make
      @controller.instance_variable_set(:@section, @section)
    end

    context '#section_news_posts' do
      setup do
        2.times { NewsPost.make :section => @section }
        2.times { NewsPost.make(:unpublished, :section => @section) }
        2.times { NewsPost.make :section => Section.make }
      end

      context 'and in the about section' do
        setup do
          @section = Section.make(:about)
          @controller.instance_variable_set(:@section, @section)
        end

        should 'return all news posts' do
          assert_equal NewsPost.published,
            @controller.send(:section_news_posts)
        end
      end

      context 'and not in the about section' do
        should "return this section's news posts" do
          assert_equal @section.news_posts.published,
            @controller.send(:section_news_posts)
        end
      end
    end

    context '#section_testimonials' do
      setup do
        2.times { Testimonial.make :section => @section }
        2.times { Testimonial.make :section => Section.make }
      end

      context 'and in the about section' do
        setup do
          @section = Section.make(:about)
          @controller.instance_variable_set(:@section, @section)
        end

        should 'return all testimonials' do
          assert_equal Testimonial.all,
            @controller.send(:section_testimonials)
        end
      end

      context 'and not in the about section' do
        should "return this section's testimonials" do
          assert_equal @section.testimonials,
            @controller.send(:section_testimonials)
        end
      end
    end

    context '#section_awards' do
      setup do
        2.times { Award.make :section => @section }
        2.times { Award.make(:unpublished, :section => @section) }
        2.times { Award.make :section => Section.make }
      end

      context 'and in the about section' do
        setup do
          @section = Section.make(:about)
          @controller.instance_variable_set(:@section, @section)
        end

        should 'return all awards' do
          assert_equal Award.published,
            @controller.send(:section_awards)
        end
      end

      context 'and not in the about section' do
        should "return this section's awards" do
          assert_equal @section.awards.published,
            @controller.send(:section_awards)
        end
      end
    end

    context '#section_projects' do
      setup do
        4.times { Project.make :section => @section }
        2.times { Project.make :section => Section.make }
      end

      context 'and in the about section' do
        setup do
          @section = Section.make(:about)
          @controller.instance_variable_set(:@section, @section)
        end

        should 'return all awards' do
          assert_equal Project.all,
            @controller.send(:section_projects)
        end
      end

      context 'and not in the about section' do
        should "return this section's projects" do
          assert_equal @section.projects.all,
            @controller.send(:section_projects)
        end
      end
    end

    context '#latest_news_posts' do
      setup do
        4.times { NewsPost.make :section => @section }
        @posts = @controller.send(:latest_news_posts, 2)
      end

      should 'return a limited number of posts' do
        assert_equal 2, @posts.size
        assert_equal @section.news_posts.published.latest(2).all, @posts
      end
    end

    context '#latest_awards' do
      setup do
        4.times { Award.make :section => @section }
        @awards = @controller.send(:latest_awards, 2)
      end

      should 'return a limited number of awards' do
        assert_equal 2, @awards.size
        assert_equal @section.awards.published.latest(2).all,
          @awards
      end
    end
  end
end
