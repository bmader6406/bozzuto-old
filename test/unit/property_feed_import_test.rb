require 'test_helper'

class PropertyFeedImportTest < ActiveSupport::TestCase
  context "A PropertyFeedImport" do
    subject { PropertyFeedImport.new }

    should have_attached_file(:file)

    should validate_presence_of(:type)

    should validate_attachment_presence(:file)
    should validate_attachment_content_type(:file).allowing('text/xml', 'application/xml')

    context "before validations" do
      it "sets empty state to queued" do
        subject = PropertyFeedImport.new(state: nil)
        subject.valid?

        subject.state.should == "queued"
      end

      it "does not set existing state to queued" do
        subject = PropertyFeedImport.new(state: "success")
        subject.valid?

        subject.state.should_not == "queued"
      end
    end

    describe "#mark_as_queued" do
      subject do
        PropertyFeedImport.make(
          state:       "processing",
          started_at:  2.minutes.ago,
          finished_at: 1.minutes.ago
        )
      end
      
      before do
        subject.mark_as_queued
      end

      it "sets state" do
        subject.state.should == "queued"
      end

      it "clears started_at" do
        subject.started_at.should == nil
      end

      it "clears finished_at" do
        subject.finished_at.should == nil
      end
    end

    describe "#mark_as_processing" do
      subject do
        PropertyFeedImport.make(
          state:       "queued",
          started_at:  nil
        )
      end
      
      before do
        subject.mark_as_processing
      end

      it "sets state" do
        subject.state.should == "processing"
      end

      it "sets started_at" do
        subject.started_at.should_not == nil
      end
    end

    describe "#mark_as_success" do
      subject do
        PropertyFeedImport.make(
          state:       "queued",
          finished_at:  nil
        )
      end
      
      before do
        subject.mark_as_success
      end

      it "sets state" do
        subject.state.should == "success"
      end

      it "sets finished_at" do
        subject.finished_at.should_not == nil
      end
    end

    describe "#mark_as_failure" do
      subject do
        PropertyFeedImport.make(
          state:       "queued",
          finished_at:  nil,
          error:        nil
        )
      end
      
      before do
        subject.mark_as_failure("error words")
      end

      it "sets state" do
        subject.state.should == "failure"
      end

      it "sets finished_at" do
        subject.finished_at.should_not == nil
      end

      it "sets error" do
        subject.error.should == "error words"
      end
    end
  end
end
