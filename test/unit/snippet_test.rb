require 'test_helper'

class SnippetTest < ActiveSupport::TestCase
  context "Snippet" do
    subject { Snippet.make }

    should have_many(:pages)

    should validate_presence_of(:name)
    should validate_presence_of(:body)
    should validate_uniqueness_of(:name)

    describe "#typus_description" do
      it "returns the description" do
        Snippet.typus_description.should =~ /text/
      end
    end
  end
end
