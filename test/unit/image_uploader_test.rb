require 'test_helper'

class ImageUploaderTest < ActiveSupport::TestCase
  context 'ImageUploader' do
    setup { @uploader = ImageUploader.new }

    should 'only allow image files' do
      assert_equal %w(jpg jpeg gif png), @uploader.extension_white_list
    end
  end
end
