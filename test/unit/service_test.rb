require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  context 'Service' do
    setup do
      @service = Service.make
    end

    subject { @service }

    should_validate_presence_of :title, :section
    should_validate_uniqueness_of :title

    should_belong_to :section

    context 'with a slug' do
      setup do
        @title = 'Blah blah blah'
        @service = Service.new :title => @title
        @service.valid?
      end

      should 'generate a slug on validate' do
        assert_equal @title.parameterize, @service.slug
      end

      should 'use the slug as the url param' do
        assert_equal @title.parameterize, @service.to_param
      end
    end
  end
end
