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

        @page1 = Page.make(
          :title   => 'Page 1',
          :section => @section
        )
        @page2 = Page.make(
          :title   => 'Page 2',
          :section => @section,
          :parent  => @page1
        )
        @page3 = Page.make(
          :title   => 'Page 3',
          :section => @section,
          :parent  => @page2
        )

        stubs(:params).returns({})
      end

      should 'return a tree of unordered lists' do
        html = Nokogiri::HTML(pages_tree(@section.pages))

        html.at('//li//a').attributes['href'].value.should == page_url(@section, @page1)
        html.at('//li//ul//li//a').attributes['href'].value.should == page_url(@section, @page2)
        html.at('//li//ul//li//ul//li//a').attributes['href'].value.should == page_url(@section, @page3)
      end
    end
  end

  def content_for(name)
    yield
  end

  def current_page_path
    'yay/hooray'
  end
end
