require 'test_helper'

class BozzutoBlogPostTest < ActiveSupport::TestCase
  context "A Tom's Blog Post" do
    setup { @post = BozzutoBlogPost.new }

    subject { @post }

    should_have_attached_file :image

    should_validate_presence_of :header_url, :title, :url, :published_at
    should_validate_attachment_presence :image
  end
end
