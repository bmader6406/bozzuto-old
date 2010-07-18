require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  context "ApplicationHelper" do
    context '#render_meta' do
      context 'with no prefix' do
        setup do
          @page = Page.new(
            :meta_title       => 'Title!',
            :meta_description => 'Description!',
            :meta_keywords    => 'Keywords!'
          )
          expects(:content_for).with(:meta_title, @page.meta_title)
          expects(:content_for).with(:meta_description, @page.meta_description)
          expects(:content_for).with(:meta_keywords, @page.meta_keywords)
        end

        should 'send the data to content_for' do
          render_meta(@page)
        end
      end

      context 'with a prefix' do
        setup do
          @community = ApartmentCommunity.new(
            :features_meta_title       => 'Title!',
            :features_meta_description => 'Description!',
            :features_meta_keywords    => 'Keywords!'
          )
          expects(:content_for).with(:meta_title, @community.features_meta_title)
          expects(:content_for).with(:meta_description, @community.features_meta_description)
          expects(:content_for).with(:meta_keywords, @community.features_meta_keywords)
        end

        should 'send the data to content_for' do
          render_meta(@community, :features)
        end
      end
    end

    context '#bedrooms' do
      should 'properly pluralize the bedrooms count' do
        @plan = ApartmentFloorPlan.new :bedrooms => 1
        assert_equal '1 Bedroom', bedrooms(@plan)

        @plan.bedrooms = 2
        assert_equal '2 Bedrooms', bedrooms(@plan)
      end
    end

    context '#bathrooms' do
      should 'properly pluralize the bathrooms count' do
        @plan = ApartmentFloorPlan.new :bathrooms => 1
        assert_equal '1 Bathroom', bathrooms(@plan)

        @plan.bathrooms = 2.5
        assert_equal '2.5 Bathrooms', bathrooms(@plan)
      end
    end

    context '#home?' do
      should 'return true if controller is HomeController' do
        expects(:params).returns(:controller => 'home_pages')

        assert home?
      end

      should 'return false otherwise' do
        expects(:params).returns(:controller => 'blah')

        assert !home?
      end
    end

    context '#current_if' do
      context 'when calling with a hash' do
        setup do
          expects(:params).times(3).returns(:controller => 'services', :id => 2)
        end

        should 'compare with all items in params' do
          assert_equal 'current', current_if(:controller => 'services')
          assert_equal 'current', current_if(:id => 2)
          assert_nil current_if(:post => 'hooray')
        end
      end

      context 'when calling with a string' do
        setup do
          expects(:params).times(2).returns(:action => 'blah')
        end

        should 'compare with the action in params' do
          assert_equal 'current', current_if('blah')
          assert_nil current_if('booya')
        end
      end
    end

    context '#month_and_day' do
      setup do
        @date = Time.now
      end
      
      should 'return the marked up date and time' do
        html = HTML::Document.new(month_and_day(@date))
        assert_select html.root, "span.month", "#{@date.strftime('%m')}."
        assert_select html.root, "span.day", "#{@date.strftime('%d')}."
      end

      should 'be marked HTML safe' do
        assert month_and_day(@date).html_safe?
      end
    end

    context '#google_maps_javascript_tag' do
      should 'contain the API key' do
        assert_match /#{APP_CONFIG[:google_maps_api_key]}/,
          google_maps_javascript_tag
      end
    end

    context '#share_this_link' do
      should 'output p.sharethis and javascript code' do
        sharethis = HTML::Document.new(share_this_link)

        assert_select sharethis.root, 'p.sharethis'
        assert_select sharethis.root, 'script'
      end
    end

    context '#facebook_like_link' do
      should 'output div.facebook-like and iframe' do
        facebook = HTML::Document.new(facebook_like_link)

        assert_select facebook.root, 'div.facebook-like'
        assert_select facebook.root, 'iframe'
      end
    end
  end
end
