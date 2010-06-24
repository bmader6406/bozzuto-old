require 'test_helper'

class PagesHelperTest < ActionView::TestCase
  context 'PagesHelper' do
    context '#breacrumb_item' do
      should 'return the argument wrapped in an li' do
        assert_equal '<li>blah</li>', breadcrumb_item('blah')
      end
    end

    context '#breadcrumb_title' do
      should 'output the argument' do
        assert_equal 'blah', breadcrumb_title('blah')
      end
    end

    context '#pages_tree' do
      setup do
        @section = Section.make
        @page1 = Page.make :section => @section
        @page2 = Page.make :section => @section
        @page3 = Page.make :section => @section

        @page3.move_to_child_of(@page2)
        @page2.move_to_child_of(@page1)

        stubs(:params).returns({})
      end

      should 'return a tree of unordered lists' do
        list = HTML::Document.new(pages_tree(@section.pages))

        assert_select list.root, '> li > a',
          :href => page_path(@section, @page1)
        assert_select list.root, '> li > ul > li > a',
          :href => page_path(@section, @page2)
        assert_select list.root, 'li ul li ul li a',
          :href => page_path(@section, @page3)
      end
    end

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

      context '#awards_path' do
        context 'when section is a service' do
          should 'return the service path' do
            assert_equal service_section_awards_path(@service),
              awards_path(@service)
          end
        end

        context 'when section is not a service' do
          should 'return the section path' do
            assert_equal section_awards_path(@section),
              awards_path(@section)
          end
        end
      end

      context '#award_path' do
        context 'when section is a service' do
          setup { @award = Award.make(:section => @service) }

          should 'return the service path' do
            assert_equal service_section_award_path(@service, @award),
              award_path(@service, @award)
          end
        end

        context 'when section is not a service' do
          setup { @award = Award.make(:section => @section) }

          should 'return the section path' do
            assert_equal section_award_path(@section, @award),
              award_path(@section, @award)
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

  def content_for(name)
    yield
  end
end
