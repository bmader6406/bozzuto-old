require 'test_helper'

class UnderConstructionLeadTest < ActiveSupport::TestCase
  context "An Under Construction Lead" do
    subject { UnderConstructionLead.new }

    should belong_to(:apartment_community)

    should validate_presence_of(:email)
    should validate_presence_of(:first_name)
    should validate_presence_of(:last_name)

    describe "#apartment_community_title" do
      context "community is present" do
        before do
          subject.apartment_community = ApartmentCommunity.make
        end

        it "returns the title" do
          subject.apartment_community_title.should == subject.apartment_community.title
        end
      end

      context "community is not present" do
        it "returns nil" do
          subject.apartment_community_title.should == nil
        end
      end
    end

    describe "#name" do
      setup do
        subject.first_name = 'Bruce'
        subject.last_name  = 'Wayne'
      end

      it "returns the first name and last name, joined with a space" do
        subject.name.should == "Bruce Wayne"
      end
    end
  end
end
