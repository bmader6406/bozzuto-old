require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  context "ApplicationController" do
    context '#about_pages helper method' do
      context 'when no About section exists' do
        should 'return an empty array' do
          assert_equal [], @controller.send(:about_root_pages)
        end
      end

      context 'when no pages exist' do
        setup do
          @section = Section.make(:about)
        end

        should 'return an empty array' do
          assert_equal [], @controller.send(:about_root_pages)
        end
      end

      context 'when pages exist' do
        setup do
          @section = Section.make(:about)
          @page1 = Page.make :section => @section
          @page2 = Page.make :section => @section

          @page2.move_to_child_of(@page1)
        end

        should 'return the roots' do
          assert_equal @section.pages.roots,
            @controller.send(:about_root_pages)
        end
      end
    end
  end
end
