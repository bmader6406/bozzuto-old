require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  context "ApplicationController" do
    context '#states helper method' do
      setup do
        5.times { State.make }
        @states = State.ordered_by_name
      end

      should 'return all states' do
        assert_equal @states, @controller.send(:states)
      end
    end

    context '#services helper method' do
      setup do
        5.times { Section.make(:service) }
        @services = Section.services.ordered_by_title
      end

      should 'return all states' do
        assert_equal @services, @controller.send(:services)
      end
    end

    context '#about_root_pages helper method' do
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
