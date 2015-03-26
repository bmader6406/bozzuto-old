require 'test_helper'

class Bozzuto::ExternalFeed::CoreIdManagerTest < ActiveSupport::TestCase
  context "Core ID Manager" do
    describe ".assign_core_ids!" do
      context "when a property does not have the same name as any others" do
        before do
          @standalone = ApartmentCommunity.make(:title => 'Glitter City')
        end

        it "assigns the record's id to its core id" do
          expect {
            Bozzuto::ExternalFeed::CoreIdManager.assign_core_ids!
          }.to change { 
            @standalone.reload.core_id
          }.from(nil).to(@standalone.id)
        end
      end

      context "when there are multiple properties with the same name" do
        before do
          @not_in_export = ApartmentCommunity.make(:title => 'Boomtown', :included_in_export => false, :published => false)
          @in_export     = ApartmentCommunity.make(:title => 'Boomtown', :included_in_export => true,  :published => false)
        end

        it "assigns core ids equal to the community in the export" do
          Bozzuto::ExternalFeed::CoreIdManager.assign_core_ids!

          @in_export.reload.core_id.should     == @in_export.id
          @not_in_export.reload.core_id.should == @in_export.id
        end

        context "when at least one is published and included in the export" do
          before do
            @core = ApartmentCommunity.make(:title => 'Boomtown', :included_in_export => true,  :published => true)
          end

          it "assigns all properties a core id equal to that of the first property that's included in the export and published" do
            Bozzuto::ExternalFeed::CoreIdManager.assign_core_ids!

            @in_export.reload.core_id.should     == @core.id
            @not_in_export.reload.core_id.should == @core.id
            @core.reload.core_id.should          == @core.id
          end

          context "and one of the communities already has a core id" do
            before do
              @existing_id = ApartmentCommunity.make(:title => 'Boomtown', :core_id => 123)
            end

            it "ensures all communities use the core id" do
              Bozzuto::ExternalFeed::CoreIdManager.assign_core_ids!

              @in_export.reload.core_id.should     == 123
              @not_in_export.reload.core_id.should == 123
              @existing_id.reload.core_id.should   == 123
            end
          end
        end
      end
    end

    describe ".clear_core_ids!" do
      before do
        ApartmentCommunity.make(:core_id => 100)
        ApartmentCommunity.make(:core_id => 200)
        ApartmentCommunity.make(:core_id => 300)
      end

      it "sets all communities' core_ids to nil" do
        Bozzuto::ExternalFeed::CoreIdManager.clear_core_ids!

        ApartmentCommunity.all.all? { |community| community.core_id.nil? }.should == true
      end
    end

    describe "#assign_id" do
      context "if the community already has a core id" do
        before do
          ApartmentCommunity.make(:title => 'Boomtown', :core_id => 333)
          @community = ApartmentCommunity.make(:title => 'Boomtown', :core_id => 123)
        end

        subject { Bozzuto::ExternalFeed::CoreIdManager.new(@community) }

        it "does not change the existing core id" do
          expect { subject.assign_id }.to_not change { @community.reload.core_id }
        end
      end

      context "when there's a community with a matching name that has a core id" do
        before do
          ApartmentCommunity.make(:title => 'Boomtown', :core_id => 999, :included_in_export => false)
          ApartmentCommunity.make(:title => 'Boomtown', :core_id => 123, :included_in_export => true)
          @community = ApartmentCommunity.make(:title => 'Boomtown', :core_id => nil)
        end

        subject { Bozzuto::ExternalFeed::CoreIdManager.new(@community) }

        it "assigns that core id to the community" do
          subject.assign_id

          @community.reload.core_id.should == 123
        end
      end

      context "when there's a community with a matching name that does not have a core id" do
        before do
          @existing  = ApartmentCommunity.make(:title => 'Boomtown', :core_id => nil)
          @community = ApartmentCommunity.make(:title => 'Boomtown', :core_id => nil)
        end

        subject { Bozzuto::ExternalFeed::CoreIdManager.new(@community) }

        it "assigns the existing record's id as the core id" do
          subject.assign_id

          @community.reload.core_id.should == @existing.id
        end
      end
    end
  end
end
