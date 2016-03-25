require 'test_helper'

class Bozzuto::ReturnToStoreTest < ActiveSupport::TestCase
  context "A ReturnToStore" do
    before do
      @request = mock('ActionDispatch::Request')
    end

    subject { Bozzuto::ReturnToStore.new(@request) }

    describe "#get" do
      before do
        session = { :return_to => "/admin/resources" }

        @request.stubs(:session).returns(session)
      end

      it "returns the current return to path" do
        subject.get.should == "/admin/resources"
      end
    end

    describe "#set" do
      before do
        session = {}

        @request.stubs(:session).returns(session)
      end

      it "sets the current return to path" do
        subject.set("/admin/resources")
        subject.get.should == "/admin/resources"
      end
    end

    describe "#pop" do
      before do
        session = { :return_to => "/admin/resources" }

        @request.stubs(:session).returns(session)
      end

      it "clears the current return to path and returns it" do
        subject.pop.should == "/admin/resources"
        subject.get.should == nil
      end
    end
  end
end
