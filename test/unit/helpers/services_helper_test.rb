require 'test_helper'

class ServicesHelperTest < ActionView::TestCase
  context 'ServicesHelpers' do
    context "#service_nav_item" do
      setup do
        @services = []
        3.times do
          @services << Service.make
        end
      end

      should 'output an li and anchor' do
        expects(:params).returns({})
        nav = HTML::Document.new(service_nav_item(@services[0]))

        assert_select nav.root, 'li' do |li|
          assert_select 'a', { :href => service_path(@services[0]) }
        end
      end

      should 'set first class on first service' do
        expects(:params).times(2).returns({})

        nav = HTML::Document.new(service_nav_item(@services[0]))
        assert_select nav.root, 'li.first'

        nav = HTML::Document.new(service_nav_item(@services[1]))
        assert_select nav.root, 'li.first', false
      end

      should 'set the current class on the current service' do
        expects(:params).returns({ :id => @services[1].to_param })

        nav = HTML::Document.new(service_nav_item(@services[1]))
        assert_select nav.root, 'li.current'
      end
    end
  end
end
