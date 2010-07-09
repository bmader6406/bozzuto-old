require 'test_helper'
require 'flickr_mocks'

class PhotoSetTest < ActiveSupport::TestCase
  include Bozzuto::FlickrMocks

  context 'PhotoSet' do
    setup do
      @set = PhotoSet.new
    end

    should_belong_to :property
    should_belong_to :apartment_community
    should_belong_to :home_community

    should_validate_presence_of :title, :flickr_set_number

    context 'before validating' do
      setup do
        @flickr_set = FlickrSet.new('123', 'Test title')
        PhotoSet.flickr_user.stubs(:sets).returns([@flickr_set])
      end

      context 'if the set exists' do
        setup do
          @set.flickr_set_number = @flickr_set.id
          assert @set.valid?
        end

        should 'not have error messages on flickr_set_number' do
          assert_nil @set.errors.on(:flickr_set_number)
        end

        should 'set the title' do
          assert_equal @flickr_set.title, @set.title
        end
      end

      context 'if the set does not exist' do
        setup do
          @set.flickr_set_number = '456'
          assert !@set.valid?
        end

        should 'have error message on flickr_set_number' do
          assert @set.errors.on(:flickr_set_number).any?
          assert @set.errors.on(:flickr_set_number).include?('cannot be found')
        end

        should 'not set the title' do
          assert_nil @set.title
        end
      end
    end
  end
end
