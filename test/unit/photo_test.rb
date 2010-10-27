require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  context "A photo" do
    should_belong_to :photo_set
    should_have_and_belong_to_many :photo_groups

    should_validate_presence_of :title, :flickr_photo_id

    should_have_attached_file :image

    context '#in_set named scope' do
      setup do
        @set = PhotoSet.make_unsaved
        @set.stubs(:flickr_set).returns(OpenStruct.new(:title => 'photo set'))
        @set.save

        @photo_in_set = Photo.make :photo_set => @set
        @photo_not_in_set = Photo.make
      end

      should 'return photos in the set' do
        assert_equal [@photo_in_set], Photo.in_set(@set)
      end
    end
  end
end
