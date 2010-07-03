require 'test_helper'

class PageTest < ActiveSupport::TestCase
  context 'Page' do
    should_belong_to :section
    should_have_one :body_slideshow
    should_have_one :masthead_slideshow

    should_validate_presence_of :title

    context '#formatted_title' do
      setup do
        @section = Section.make
        @page1 = Page.make :section => @section
        @page2 = Page.make :section => @section

        @page2.move_to_child_of(@page1)
      end

      should 'return formatted string' do
        assert_equal @page1.title, @page1.formatted_title
        assert_equal "&nbsp;&nbsp;&nbsp;&#8627; #{@page2.title}",
          @page2.formatted_title
      end
    end

    context '#first?' do
      setup do
        @section = Section.make
        @page1 = Page.make :section => @section
        @page2 = Page.make :section => @section
      end

      should 'return true if first' do
        assert @page1.first?
      end

      should 'return false otherwise' do
        assert !@page2.first?
      end
    end

    context '#path' do
      setup do
        @section = Section.make
        @page1 = Page.make :section => @section
        @page2 = Page.make :section => @section
        @page2.move_to_child_of(@page1)
      end

      should 'return a trail of slugs' do
        assert_equal [@page1.cached_slug, @page2.cached_slug], @page2.path
      end
    end

    context '#find_by_path' do
      setup do
        @section = Section.make
        @page1 = Page.make :section => @section
        @page2 = Page.make :section => @section
        @page2.move_to_child_of(@page1)
      end

      context 'and a totally nonexistent path' do
        should 'raise a not found exception' do
          assert_raise(ActiveRecord::RecordNotFound) do
            @section.pages.find_by_path 'blaugh'
          end
        end
      end

      context 'and a partially matching path' do
        should 'raise a not found exception' do
          assert_raise(ActiveRecord::RecordNotFound) do
            @section.pages.find_by_path "blaugh/#{@page2.cached_slug}"
          end
        end
      end

      context 'and a fully matching path' do
        should 'return the page' do
          assert_nothing_raised(ActiveRecord::RecordNotFound) do
            page = @section.pages.find_by_path "#{@page1.cached_slug}/#{@page2.cached_slug}"
            assert_equal @page2, page
          end
        end
      end
    end
  end
end
