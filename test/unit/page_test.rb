require 'test_helper'

class PageTest < ActiveSupport::TestCase
  context 'Page' do
    should_belong_to :section
    should_have_one :body_slideshow
    should_have_one :masthead_slideshow
    should_have_one :carousel

    should_validate_presence_of :title
    
    should_have_attached_file :left_montage_image
    should_have_attached_file :middle_montage_image
    should_have_attached_file :right_montage_image
    
    should 'be archivable' do
      assert Page.acts_as_archive?
      assert_nothing_raised do
        Page::Archive
      end
      assert defined?(Page::Archive)
      assert_equal ActiveRecord::Base, Page::Archive.superclass
    end

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

    context '#to_param' do
      setup do
        @section = Section.make
        @page1 = Page.make :section => @section
        @page2 = Page.make :section => @section
        @page2.move_to_child_of(@page1)
        @page2.save
      end

      should 'return the path' do
        assert_equal @page1.cached_slug, @page1.to_param
        assert_equal "#{@page1.cached_slug}/#{@page2.cached_slug}", @page2.to_param
      end
    end

    context 'when saving' do
      setup do
        @section = Section.make
        @page1 = Page.make :section => @section
        @page2 = Page.make :section => @section
        @page2.move_to_child_of(@page1)
        @page2.save
      end

      should 'automatically update the path' do
        assert_equal [@page1.cached_slug, @page2.cached_slug].join('/'),
          @page2.path
      end
    end
    
    context '#montage?' do
      setup do
        @page = Page.make
      end
      
      context 'when all montage images are present' do
        setup do
          @page.expects(:left_montage_image?).returns(true)
          @page.expects(:middle_montage_image?).returns(true)
          @page.expects(:right_montage_image?).returns(true)
        end

        should 'return true' do
          assert @page.montage?
        end
      end

      context 'when any montage images are missing' do
        setup do
          @page.expects(:left_montage_image?).returns(false)
          @page.stubs(:middle_montage_image?).returns(true)
          @page.stubs(:right_montage_image?).returns(true)
        end

        should 'return true' do
          assert !@page.montage?
        end
      end
    end
  end
end
