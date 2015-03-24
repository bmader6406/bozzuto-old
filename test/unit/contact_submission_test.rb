require 'test_helper'

class ContactSubmissionTest < ActiveSupport::TestCase
  context "ContactSubmission" do
    subject { ContactSubmission.new }

    [:name, :email, :topic_id, :message].each do |attr|
      it "validates presence of #{attr}" do
        subject.valid?

        subject.errors[attr].should include("can't be blank")
      end
    end

    describe "#topic" do
      before do
        @topic = ContactTopic.make
        subject.topic_id = @topic.id
      end

      it "returns the ContactTopic matching its topic_id" do
        subject.topic.should == @topic
      end
    end

    describe "#topic=" do
      before do
        @topic = ContactTopic.make
      end

      it "sets the topic to the given topic" do
        subject.topic = @topic

        subject.topic_id.should == @topic.id
      end
    end

    describe "#attributes" do
      before do
        @topic = ContactTopic.make
      end

      subject do
        ContactSubmission.new(
          :name     => 'Name',
          :email    => 'email@test.com',
          :message  => 'Test',
          :topic_id => @topic.id
        )
      end

      it "returns a hash of attributes and their values" do
        subject.attributes.should == {
          :name     => 'Name',
          :email    => 'email@test.com',
          :message  => 'Test',
          :topic_id => @topic.id
        }
      end
    end

    describe "#persisted?" do
      it "returns false" do
        subject.persisted?.should == false
      end
    end
  end
end
