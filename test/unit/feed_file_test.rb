require 'test_helper'

class FeedFileTest < ActiveSupport::TestCase
  context "FeedFile" do
    should belong_to(:feed_record)

    should validate_presence_of(:feed_record)
    should validate_presence_of(:external_cms_id)
    should validate_presence_of(:external_cms_type)
    should validate_presence_of(:name)
    should validate_presence_of(:format)
    should validate_presence_of(:source)

    FeedFile::FILE_TYPE.each do |type|
      should allow_value(type).for(:file_type)
    end

    should allow_value(nil).for(:file_type)
    should_not allow_value('random').for(:file_type)
  end
end
