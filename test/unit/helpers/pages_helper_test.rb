require 'test_helper'

class PagesHelperTest < ActionView::TestCase
  context 'PagesHelper' do
    context 'path helpers' do
      setup do
        @section = Section.make
        @service = Section.make(:service)
      end

      context '#page_path' do
        context 'when section is a service' do
          setup { @page = Page.make(:section => @service) }

          should 'return the service path' do
            assert_equal service_section_page_path(@service, @page),
              page_path(@service, @page)
          end
        end

        context 'when section is not a service' do
          setup { @page = Page.make(:section => @section) }

          should 'return the section path' do
            assert_equal section_page_path(@section, @page),
              page_path(@section, @page)
          end
        end
      end

      context '#news_posts_path' do
        context 'when section is a service' do
          should 'return the service path' do
            assert_equal service_section_news_posts_path(@service),
              news_posts_path(@service)
          end
        end

        context 'when section is not a service' do
          should 'return the section path' do
            assert_equal section_news_posts_path(@section),
              news_posts_path(@section)
          end
        end
      end

      context '#news_post_path' do
        context 'when section is a service' do
          setup { @post = NewsPost.make(:section => @service) }

          should 'return the service path' do
            assert_equal service_section_news_post_path(@service, @post),
              news_post_path(@service, @post)
          end
        end

        context 'when section is not a service' do
          setup { @post = NewsPost.make(:section => @section) }

          should 'return the section path' do
            assert_equal section_news_post_path(@section, @post),
              news_post_path(@section, @post)
          end
        end
      end

      context '#testimonials_path' do
        context 'when section is a service' do
          should 'return the service path' do
            assert_equal service_section_testimonials_path(@service),
              testimonials_path(@service)
          end
        end

        context 'when section is not a service' do
          should 'return the section path' do
            assert_equal section_testimonials_path(@section),
              testimonials_path(@section)
          end
        end
      end

    end
  end
end
