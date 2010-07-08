require 'test_helper'
require 'flickr_mocks'

class PhotoSetTest < ActiveSupport::TestCase
  include Bozzuto::FlickrMocks

  context 'PhotoSet' do
    setup do
      @set = PhotoSet.new
    end

    should_belong_to :community

    should_validate_presence_of :title, :flickr_set_id

    context 'before validating' do
      setup do
        @flickr_set = FlickrSet.new('123', 'Test title')
        PhotoSet.flickr_user.expects(:sets).returns([@flickr_set])
      end

      context 'if the set exists' do
        setup do
          @set.flickr_set_id = @flickr_set.id
          assert @set.valid?
        end

        should 'not have error messages on flickr_set_id' do
          assert_nil @set.errors.on(:flickr_set_id)
        end

        should 'set the title' do
          assert_equal @flickr_set.title, @set.title
        end
      end

      context 'if the set does not exist' do
        setup do
          @set.flickr_set_id = '456'
          assert !@set.valid?
        end

        should 'have error message on flickr_set_id' do
          assert @set.errors.on(:flickr_set_id).any?
          assert @set.errors.on(:flickr_set_id).include?('cannot be found')
        end

        should 'not set the title' do
          assert_nil @set.title
        end
      end
    end
  end
end
