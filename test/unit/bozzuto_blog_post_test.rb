require 'test_helper'

class BozzutoBlogPostTest < ActiveSupport::TestCase
  context "A Tom's Blog Post" do
    setup { @post = BozzutoBlogPost.new }

    subject { @post }

    should_have_attached_file :image

    should_validate_presence_of :header_url, :title, :url, :published_at
    should_validate_attachment_presence :image

    %w(header_url url).each do |attr|
      context "with a valid #{attr}" do
        setup do
          @post.send("#{attr}=", 'http://batman.com')
          @post.valid?
        end

        should "not have errors on #{attr}" do
          assert_nil @post.errors.on(attr)
        end
      end

      context "with an invalid #{attr}" do
        setup do
          @post.send("#{attr}=", 'batman.com')
          @post.valid?
        end

        should "not have errors on #{attr}" do
          assert @post.errors.on(attr)
          assert_match /is not a valid URL/, @post.errors.on(attr)
        end
      end
    end
  end
end
