require 'test_helper'

module Bozzuto::ExternalFeed
  class ModelTest < ActiveSupport::TestCase
    context "A resource instance" do
      %w(vaultware property_link rent_cafe psi).each do |type|
        context "when managed by #{type.titlecase}" do
          before do
            @community = ApartmentCommunity.make(type.to_sym)
          end

          context "#managed_by_#{type}?" do
            it "returns true" do
              @community.send("managed_by_#{type}?").should == true
            end
          end

          context "#managed_externally?" do
            it "be true" do
              @community.managed_externally?.should == true
            end
          end

          context "#external_cms_name" do
            it "sends #feed_name on ExternalFeedLoader" do
              Bozzuto::ExternalFeed::Feed.expects(:feed_name).with(type)

              @community.external_cms_name
            end
          end
        end

        context "when community is not managed by #{type.titlecase}" do
          setup { @community = ApartmentCommunity.make }

          it "returns false" do
            @community.send("managed_by_#{type}?").should == false
          end
        end
      end
    end

    context "The resource class" do
      setup do
        @vaultware     = ApartmentCommunity.make(:vaultware)
        @property_link = ApartmentCommunity.make(:property_link)
        @other         = ApartmentCommunity.make
      end

      describe "managed_by_* named scopes" do
        context "vaultware" do
          it "returns only the Vaultware resources" do
            ApartmentCommunity.managed_by_vaultware.all.should == [@vaultware]
          end
        end

        context "property_link" do
          it "returns only the PropertyLink resources" do
            ApartmentCommunity.managed_by_property_link.all.should == [@property_link]
          end
        end
      end

      describe "#managed_by_feed" do
        it "returns the resource" do
          ApartmentCommunity.managed_by_feed(@vaultware.external_cms_id, @vaultware.external_cms_type).should == [@vaultware]
        end
      end

      context "managed_locally named scope" do
        it "returns only the local resource" do
          ApartmentCommunity.managed_locally.should == [@other]
        end
      end
    end
  end
end
