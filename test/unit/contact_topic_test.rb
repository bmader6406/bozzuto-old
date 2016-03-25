require 'test_helper'

class ContactTopicTest < ActiveSupport::TestCase
  context 'Contact topic' do
    subject { ContactTopic.make }

    should belong_to(:section)

    should validate_presence_of(:topic)
    should validate_presence_of(:recipients)
    should validate_uniqueness_of(:topic)

    describe "#to_s" do
      it "returns the topic" do
        subject.to_s.should == subject.topic
      end
    end
  end
end
