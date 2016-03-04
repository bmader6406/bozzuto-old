require 'test_helper'

class FileUploadTest < ActiveSupport::TestCase
  context "FileUpload" do
    should have_attached_file(:file)

    should validate_presence_of(:file)
  end
end
