require 'test_helper'

class PagesHelperTest < ActionView::TestCase
  context 'PagesHelper' do
    context '#render_aside' do
      setup do
        @section = Section.make :title => 'Blah blah blah'
      end

      context 'with a partial that exists' do
        should 'render the partial' do
          assert_equal 'pages/blah_blah_blah_aside', render_aside
        end
      end
    end


  #def about_and_services_slideshow_attrs
  #  if ['about-us', 'services'].include?(@section.cached_slug) && @page == @section.pages.first
  #    raw(%{data-sync="true" data-interval="8000"})
  #  end
  #end


    context '#about_and_services_slideshow_attrs' do
      ['About Us', 'Services'].each do |name|
        context "in the '#{name}' section" do
          setup do
            @section = Section.make :title => name
            @page = Page.make :section => @section
          end

          should 'return the data attribute' do
            assert_equal raw('data-sync="true" data-interval="8000"'), about_and_services_slideshow_attrs
          end
        end
      end

      context "not in 'About US' or 'Services'" do
        setup do
          @section = Section.make :title => 'Hey Ya'
          @page = Page.make :section => @section
        end

        should 'return nil' do
          assert_nil about_and_services_slideshow_attrs
        end
      end
    end
  end

  def render(opts)
    opts[:partial]
  end
end
