require 'test_helper'

class ContactSubmissionsHelperTest < ActionView::TestCase
  include OverriddenPathsHelper

  context 'ContactSubmissionsHlper' do
    context '#corporate_office_map_uri' do
      setup do
        @lat = 38.999647
        @lon = -76.89595
      end

      context 'on an iPhone' do
        should 'return the map url' do
          url = "http://maps.google.com/maps?q=#{@lat},#{@lon}"
          stubs(:device).returns(:iphone)

          assert_equal url, corporate_office_map_uri
        end
      end

      context 'on Android' do
        should 'return the map url' do
          url = "geo:#{@lat},#{@lon}"
          stubs(:device).returns(:android)

          assert_equal url, corporate_office_map_uri
        end
      end

      context 'on BlackBerry' do
        should 'return the map url' do
          url = contact_path(:format => :kml)
          stubs(:device).returns(:blackberry)

          assert_equal url, corporate_office_map_uri
        end
      end
    end

    context '#contact_path_with_topic' do
      context 'when section is a service' do
        setup do
          @section = Section.make(:service, :title => 'Construction')
        end

        should 'set the topic to service' do
          assert_equal contact_path(:topic => 'construction'),
            contact_path_with_topic
        end
      end

      context 'when section is not a service' do
        setup do
          @section = Section.make
        end

        should 'set the topic to general_inquiry' do
          assert_equal contact_path(:topic => 'general_inquiry'),
            contact_path_with_topic
        end
      end
    end
  end
end
