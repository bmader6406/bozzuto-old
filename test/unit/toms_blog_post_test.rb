require 'test_helper'

class TomsBlogPostTest < ActiveSupport::TestCase
  context "A Tom's Blog Post" do
    setup { @post = TomsBlogPost.new }

    subject { @post }

    should_have_attached_file :image

    should_validate_presence_of :title, :url, :published_at
    should_validate_attachment_presence :image
  end
end
