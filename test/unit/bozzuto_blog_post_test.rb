require 'test_helper'

class BozzutoBlogPostTest < ActiveSupport::TestCase
  context "A Tom's Blog Post" do
    subject { BozzutoBlogPost.new }

    should have_attached_file(:image)

    should validate_presence_of(:header_url)
    should validate_presence_of(:title)
    should validate_presence_of(:url)
    should validate_presence_of(:published_at)
    should validate_attachment_presence(:image)

    %w(header_url url).each do |attr|
      context "with a valid #{attr}" do
        before do
          subject.send("#{attr}=", 'http://batman.com')

          subject.valid?
        end

        should "not have errors on #{attr}" do
          subject.errors[attr].should == []
        end
      end

      context "with an invalid #{attr}" do
        before do
          subject.send("#{attr}=", 'batman.com')

          subject.valid?
        end

        it "doesn't have errors on #{attr}" do
          subject.errors[attr].to_s.should =~ /is not a valid URL/
        end
      end
    end

    describe "#to_s" do
      it "returns the title" do
        subject.to_s.should == subject.title
      end
    end
  end
end
