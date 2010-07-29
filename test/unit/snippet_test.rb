require 'test_helper'

class SnippetTest < ActiveSupport::TestCase
  context "Snippet" do
    setup do
      @snippet = Snippet.make
    end

    subject { @snippet }

    should_validate_presence_of :name, :body
    should_validate_uniqueness_of :name

    context '#typus_description' do
      should 'return the description' do
        assert_match /text/, Snippet.typus_description
      end
    end
  end
end
