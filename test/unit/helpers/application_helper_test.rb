require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  context "ApplicationHelper" do
    context '#bedrooms' do
      should 'properly pluralize the bedrooms count' do
        @plan = FloorPlan.new :bedrooms => 1
        assert_equal '1 Bedroom', bedrooms(@plan)

        @plan.bedrooms = 2
        assert_equal '2 Bedrooms', bedrooms(@plan)
      end
    end

    context '#bathrooms' do
      should 'properly pluralize the bathrooms count' do
        @plan = FloorPlan.new :bathrooms => 1
        assert_equal '1 Bathroom', bathrooms(@plan)

        @plan.bathrooms = 2.5
        assert_equal '2.5 Bathrooms', bathrooms(@plan)
      end
    end

    context '#home?' do
      should 'return true if controller is HomeController' do
        expects(:params).returns(:controller => 'home')

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
  end
end
