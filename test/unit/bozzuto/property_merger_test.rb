require 'test_helper'

class PropertyMergerTest < ActiveSupport::TestCase
  context "Bozzuto::PropertyMerger" do
    before do
      @property = ApartmentCommunity.make(external_cms_type: nil, external_cms_id: nil)
      @target   = ApartmentCommunity.make(external_cms_type: 'psi', external_cms_id: '1337')
      @params   = HashWithIndifferentAccess.new(bozzuto_property_merger: { target_property_id: @target.id })
    end

    subject do
      Bozzuto::PropertyMerger.new(@property).process(@params)
    end

    describe "#process" do
      it "sets the target property ID" do
        subject.target_property_id.should == @target.id
      end
    end

    describe "#target_property" do
      it "returns the target property based on the target property ID" do
        subject.target_property.should == @target
      end
    end

    describe "#target_merge_properties" do
      it "returns a list of possible target properties for the merge sorted by feed" do
        subject.target_merge_properties.should == [['PSI', [[@target.title, @target.id]]]]
      end
    end

    describe "#feed_name" do
      it "returns the feed name of the target property" do
        subject.feed_name.should == 'PSI'
      end
    end

    describe "#to_s" do
      context "pre-merge" do
        it "returns a description of the planned merge" do
          subject.to_s.should == "Merging #{@property} with #{@target}"
        end
      end

      context "post-merge" do
        before { subject.merge! }

        it "returns a description of the completed merge" do
          subject.to_s.should == "Merged #{@property} with #{@target}"
        end
      end
    end

    describe "#merge!" do
      it "merges the given property with the target property" do
        @property.expects(:merge).with(@target)

        subject.merge!
      end
    end
  end
end
