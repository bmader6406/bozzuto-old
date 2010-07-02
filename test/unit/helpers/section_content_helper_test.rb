require 'test_helper'

class SectionContentHelperTest < ActionView::TestCase
  include OverriddenPathsHelper

  context 'SectionContentHelper' do
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
  end

  def content_for(name)
    yield
  end
end
