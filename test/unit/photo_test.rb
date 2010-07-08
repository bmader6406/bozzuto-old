require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  context "A photo" do
    should_belong_to :photo_set
    should_have_and_belong_to_many :photo_groups

    should_validate_presence_of :title, :flickr_photo_id

    should_have_attached_file :image
  end
end
