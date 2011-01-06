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

    context '#mobile? helper method' do
      context 'when request format is not :mobile' do
        setup { @controller.request.format = :html }

        should 'return false' do
          assert !@controller.send(:mobile?)
        end
      end

      context 'when request format is :mobile' do
        setup { @controller.request.format = :mobile }

        should 'return true' do
          assert @controller.send(:mobile?)
        end
      end
    end
  
    context '#page_url method' do
      setup do
        @section = Section.make
        @service = Section.make(:service)
        @news_press = Section.make(:title => 'News & Press')
      end

      context 'when section is a service' do
        setup { @page = Page.make(:section => @service) }

        should 'return the service path' do
          assert_equal service_section_page_url(@service, @page),
            @controller.send(:page_url, @service, @page)
        end
      end

      context 'when section is not a service' do
        setup { @page = Page.make(:section => @section) }

        should 'return the section path' do
          assert_equal section_page_url(@section, @page),
            @controller.send(:page_url, @section, @page)
        end
      end
      
      context 'when section is news & press' do
        setup { @page = Page.make(:section => @news_press) }

        should 'return the section path' do
          assert_equal news_and_press_page_url(@page),
            @controller.send(:page_url, @news_press, @page)
        end
      end
    end
  end
end
