require 'test_helper'

class PagesHelperTest < ActionView::TestCase
  include OverriddenPathsHelper

  context 'PagesHelper' do
    context '#mobile_back_link_for' do
      context 'when page is first' do
        context 'and section is a service' do
          setup do
            @section = Section.make(:service)
            @page    = Page.make :section => @section
          end

          should 'return a link to the "Our Services" page' do
            link = mobile_back_link_for(@section, @page)

            assert_match /Our Services/, link
            assert_match /"\/services"/, link
          end
        end

        context 'and section is not a service' do
          setup do
            @section = Section.make
            @page    = Page.make :section => @section
          end

          should 'return a link to the home page' do
            link = mobile_back_link_for(@section, @page)

            assert_match /Home/, link
            assert_match /#{root_path}/, link
          end
        end
      end

      context 'when page is not first' do
        context 'and is nested within other pages' do
          setup do
            @section = Section.make
            @parent  = Page.make :section => @section
            @page    = Page.make :section => @section, :parent => @parent
          end

          should 'return a link to the parent' do
            link = mobile_back_link_for(@section, @page)

            assert_match /#{@parent.title}/, link
            assert_match /#{page_path(@section, @parent)}/, link
          end
        end

        context 'and is a root level page' do
          setup do
            @section = Section.make
            @first   = Page.make :section => @section
            @page    = Page.make :section => @section
          end

          should 'return a link to the section' do
            link = mobile_back_link_for(@section, @page)

            assert_match /#{@section.title}/, link
            assert_match /#{page_path(@section)}/, link
          end
        end
      end
    end


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
