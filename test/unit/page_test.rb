require 'test_helper'

class PageTest < ActiveSupport::TestCase
  context 'Page' do
    should_belong_to :section

    should_validate_presence_of :title

    context 'on #path' do
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
  end
end
