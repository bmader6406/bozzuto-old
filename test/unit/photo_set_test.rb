require 'test_helper'
require 'flickr_mocks'

class PhotoSetTest < ActiveSupport::TestCase
  include Bozzuto::FlickrMocks

  context 'PhotoSet' do
    setup do
      @set = PhotoSet.new

      @flickr_set1 = FlickrSet.new('123', 'Title')
      @flickr_set2 = FlickrSet.new('456', 'Another title')

      @flickr_user = mock
      @flickr_user.stubs(:sets).returns([@flickr_set1, @flickr_set2])

      PhotoSet.stubs(:flickr_user).returns(@flickr_user)
    end

    should_belong_to :property
    should_belong_to :apartment_community
    should_belong_to :home_community

    should_validate_presence_of :title, :flickr_set_number

    context 'before validating' do
      context 'if the set exists' do
        setup do
          @set.flickr_set_number = @flickr_set1.id
          assert @set.valid?
        end

        should 'not have error messages on flickr_set_number' do
          assert_nil @set.errors.on(:flickr_set_number)
        end

        should 'set the title' do
          assert_equal @flickr_set1.title, @set.title
        end
      end

      context 'if the set does not exist' do
        setup do
          @set.flickr_set_number = '1'
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

    context 'on save' do
      context 'flickr_set_number has changed' do
        should 'mark as needing sync' do
          @set.flickr_set_number = '456'

          assert @set.flickr_set_number_changed?
          @set.save
          assert @set.needs_sync
        end
      end

      context 'flickr_set_number has not changed' do
        should 'not mark as needing sync' do
          assert !@set.flickr_set_number_changed?
          @set.save
          assert !@set.needs_sync
        end
      end
    end

    context 'needs_sync named scope' do
      setup do
        @set1 = PhotoSet.make :flickr_set_number => @flickr_set1.id
        @set2 = PhotoSet.make :flickr_set_number => @flickr_set2.id
        @set3 = PhotoSet.make :flickr_set_number => @flickr_set1.id

        @set1.needs_sync = false
        @set1.save
      end

      should 'return only the sets needing sync' do
        assert !@set1.needs_sync
        assert @set2.needs_sync
        assert @set3.needs_sync

        assert_equal [@set2, @set3], PhotoSet.needs_sync.all
      end
    end
  end
end
