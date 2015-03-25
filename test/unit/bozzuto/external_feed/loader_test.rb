require 'test_helper'

module Bozzuto::ExternalFeed
  class LoaderTest < ActiveSupport::TestCase
    def touch_file(file)
      FileUtils.touch(file)
    end

    def rm_file(file)
      File.delete(file) if File.exists?(file)
    end

    def setup_loader_stubs(thing)
      thing.expects(:can_load?).returns(true)
      thing.expects(:touch_lock_file)
      thing.expects(:touch_tmp_file)
      thing.expects(:rm_lock_file)
    end

    context "A feed loader" do
      before do
        create_states
        create_floor_plan_groups
      end

      subject { Bozzuto::ExternalFeed::Loader.loader_for_type(:vaultware) }

      describe "#feed_name" do
        it "returns the feed's name" do
          subject.feed_name.should == 'Vaultware'
        end
      end

      describe "#feed_type" do
        it "returns the feed's type" do
          subject.feed_type.should == :vaultware
        end
      end

      describe "#already_loading?" do
        before do
          rm_file(subject.lock_file)
        end

        context "lock file doesn't exist" do
          it "returns false" do
            subject.already_loading?.should == false
          end
        end

        context "lock file exists" do
          before do
            touch_file(subject.lock_file)
          end

          after do
            rm_file(subject.lock_file)
          end

          it "returns true" do
            subject.already_loading?.should == true
          end
        end
      end

      describe "#last_loaded_at" do
        context "tmp file exists" do
          before do
            touch_file(subject.tmp_file)

            @time = File.mtime(subject.tmp_file)
          end

          after do
            rm_file(subject.tmp_file)
          end

          it "returns the modified time" do
            subject.last_loaded_at.should == @time
          end
        end

        context "tmp file doesn't exist" do
          before do
            rm_file(subject.tmp_file)
          end

          it "returns nil" do
            subject.last_loaded_at.should == nil
          end
        end
      end

      describe "#can_load?" do
        context "feed is already loading" do
          before do
            subject.expects(:already_loading?).returns(true)
          end

          it "returns false" do
            subject.can_load?.should == false
          end
        end

        context "time isn't past load interval" do
          before do
            subject.expects(:already_loading?).returns(false)
            subject.expects(:next_load_at).returns(Time.now + 10.minutes)
          end

          it "returns false" do
            subject.can_load?.should == false
          end
        end

        context "feed isn't loading and time is past load interval" do
          before do
            subject.expects(:already_loading?).returns(false)
            subject.expects(:next_load_at).returns(Time.now - 10.minutes)
          end

          it "returns true" do
            subject.can_load?.should == true
          end
        end
      end

      describe "#next_load_at" do
        context "last_loaded_at is present" do
          before do
            subject.expects(:last_loaded_at).times(2).returns(Time.now)
          end

          it "returns last_loaded_at plus 2 hours" do
            subject.next_load_at.should be_within(1.seconds).of(Time.now + subject.load_interval)
          end
        end

        context "last_loaded_at isn't present" do
          before do
            subject.expects(:last_loaded_at).returns(nil)
          end

          it "returns the current time minus 1 minute" do
            subject.next_load_at.should be_within(1.seconds).of(Time.now - 1.minute)
          end
        end
      end

      describe "#load!" do
        subject do
          Bozzuto::ExternalFeed::Loader.loader_for_type(:vaultware, :file => Rails.root.join('test/files/vaultware.xml'))
        end

        context "feed is already loading" do
          before do
            subject.expects(:can_load?).returns(false)
          end

          it "returns false" do
            expect {
              expect {
                subject.load!.should == false
              }.to_not change { ApartmentFloorPlan.count }
            }.to_not change { ApartmentCommunity.count }
          end
        end

        context "doesn't raise an exception" do
          before do
            subject.expects(:can_load?).returns(true)
          end

          it "correctly manages the tmp files" do
            subject.expects(:touch_lock_file)
            subject.expects(:process_feed)
            subject.expects(:touch_tmp_file)
            subject.expects(:rm_lock_file)

            subject.load!.should == true
          end
        end

        context "raises an exception" do
          before do
            subject.expects(:can_load?).returns(true)
          end

          it "correctly manages the tmp files" do
            subject.expects(:touch_lock_file)
            subject.expects(:process_feed).raises(Exception)
            subject.expects(:touch_tmp_file).times(0)
            subject.expects(:rm_lock_file)

            expect {
              subject.load!.should == false
            }.to raise_error(Exception)
          end
        end

        context "community doesn't exist" do
          before do
            setup_loader_stubs(subject)
          end

          it "creates the community and floor plans" do
            expect {
              expect {
                subject.load!
              }.to change { ApartmentCommunity.count }.by(2)
            }.to change { ApartmentFloorPlan.count }.by(3)

            ::ApartmentCommunity.all[0].tap do |c|
              c.core_id.should           == c.id
              c.title.should             == 'Hunters Glen'
              c.street_address.should    == '14210 Slidell Court'
              c.city.should              == City.find_by_name('Upper Marlboro')
              c.state.should             == State.find_by_code('MD')
              c.availability_url.should  == 'http://units.realtydatatrust.com/unittype.aspx?ils=5341&propid=14317'
              c.external_cms_id.should   == '14317'
              c.external_cms_type.should == 'vaultware'

              c.office_hours.first.tap do |office_hour|
                office_hour.day.should              == 0
                office_hour.opens_at.should         == '12:00'
                office_hour.opens_at_period.should  == 'PM'
                office_hour.closes_at.should        == '5:00'
                office_hour.closes_at_period.should == 'PM'
              end

              c.office_hours.last.tap do |office_hour|
                office_hour.day.should              == 6
                office_hour.opens_at.should         == '10:00'
                office_hour.opens_at_period.should  == 'AM'
                office_hour.closes_at.should        == '5:00'
                office_hour.closes_at_period.should == 'PM'
              end

              c.floor_plans[0].tap do |p|
                p.name.should              == '1 Bedroom 1 Bath'
                p.availability_url.should  == 'http://units.realtydatatrust.com/unitavailability.aspx?ils=5341&fid=9797'
                p.available_units.should   == 3
                p.bedrooms.should          == 1
                p.bathrooms.should         == 1
                p.min_square_feet.should   == 780
                p.max_square_feet.should   == 780
                p.min_rent.should          == 1480
                p.max_rent.should          == 1505
                p.image_url.should         == 'http://cdn.realtydatatrust.com/i/fs/27983'
                p.floor_plan_group.should  == ApartmentFloorPlanGroup.one_bedroom
                p.external_cms_id.should   == '9797'
                p.external_cms_type.should == 'vaultware'
              end

              c.floor_plans[1].tap do |p|
                p.name.should              == '1 Bedroom W/Den, 1 Bath'
                p.availability_url.should  == 'http://units.realtydatatrust.com/unitavailability.aspx?ils=5341&fid=9798'
                p.available_units.should   == 1
                p.bedrooms.should          == 1
                p.bathrooms.should         == 1
                p.min_square_feet.should   == 881
                p.max_square_feet.should   == 881
                p.min_rent.should          == 1585
                p.max_rent.should          == 1585
                p.image_url.should         == 'http://cdn.realtydatatrust.com/i/fs/27989'
                p.floor_plan_group.should  == ApartmentFloorPlanGroup.one_bedroom
                p.external_cms_id.should   == '9798'
                p.external_cms_type.should == 'vaultware'
              end
            end

            ::ApartmentCommunity.all[1].tap do |c|
              c.core_id.should           == c.id
              c.title.should             == 'The Courts of Devon'
              c.street_address.should    == '501 Main Street'
              c.city.should              == City.find_by_name('Gaithersburg')
              c.state.should             == State.find_by_code('MD')
              c.availability_url.should  == 'http://units.realtydatatrust.com/unittype.aspx?ils=5341&propid=16976'
              c.external_cms_id.should   == '16976'
              c.external_cms_type.should == 'vaultware'

              c.office_hours.first.tap do |office_hour|
                office_hour.day.should              == 0
                office_hour.opens_at.should         == '12:00'
                office_hour.opens_at_period.should  == 'PM'
                office_hour.closes_at.should        == '5:00'
                office_hour.closes_at_period.should == 'PM'
              end

              c.office_hours.last.tap do |office_hour|
                office_hour.day.should              == 6
                office_hour.opens_at.should         == '10:00'
                office_hour.opens_at_period.should  == 'AM'
                office_hour.closes_at.should        == '5:00'
                office_hour.closes_at_period.should == 'PM'
              end

              c.floor_plans[0].tap do |p|
                p.name.should              == '2 Bedroom/1 Bath'
                p.availability_url.should  == 'http://units.realtydatatrust.com/unitavailability.aspx?ils=5341&fid=20294'
                p.available_units.should   == 5
                p.bedrooms.should          == 2
                p.bathrooms.should         == 1
                p.min_square_feet.should   == 761
                p.max_square_feet.should   == 833
                p.min_rent.should          == 1540
                p.max_rent.should          == 1820
                p.image_url.should         == 'http://cdn.realtydatatrust.com/i/fs/62315'
                p.floor_plan_group.should  == ApartmentFloorPlanGroup.two_bedrooms
                p.external_cms_id.should   == '20294'
                p.external_cms_type.should == 'vaultware'
              end
            end
          end

          context "with a 'duplicate' property from another feed" do
            before do
              ApartmentCommunity.make(:title => 'The Courts of Devon', :core_id => 111)
            end

            it "assigns the core id based on the existing duplicate" do
              subject.load!

              community = ApartmentCommunity.find_by_title_and_external_cms_type('The Courts of Devon', 'vaultware')

              community.reload.core_id.should == 111
            end
          end
        end

        context "community doesn't have a valid address" do
          subject { Bozzuto::ExternalFeed::Loader.loader_for_type(:vaultware) }

          before do
            setup_loader_stubs(subject)

            subject.file = Rails.root.join('test/files/vaultware_no_address.xml')
          end

          it "doesn't load the community or its floor plans" do
            expect {
              expect {
                subject.load!
              }.to_not change { ApartmentFloorPlan.count }
            }.to_not change { ApartmentCommunity.count }
          end
        end

        context "community exists" do
          before do
            setup_loader_stubs(subject)

            @community = ApartmentCommunity.make(:vaultware,
              :external_cms_id  => '16976',
              :core_id          => 123,
              :title            => 'TEST',
              :street_address   => 'TEST',
              :availability_url => 'TEST'
            )
          end

          context "floor plan exists that isn't in the feed" do
            before do
              @plan = ApartmentFloorPlan.make(:vaultware,
                :external_cms_id     => '123456789',
                :apartment_community => @community,
                :name                => 'ORPHAN',
                :availability_url    => 'ORPHAN',
                :bedrooms            => 99,
                :bathrooms           => 99,
                :min_square_feet     => 9999,
                :max_square_feet     => 9999,
                :min_rent            => 9999,
                :max_rent            => 9999,
                :image_url           => 'ORPHAN',
                :floor_plan_group    => ApartmentFloorPlanGroup.studio
              )
            end

            it "destroys the orphaned floor plan" do
              expect {
                expect {
                  subject.load!
                }.to change { ApartmentCommunity.count }.by(1)
              }.to change { ApartmentFloorPlan.count }.by(2)

              expect {
                @plan.reload
              }.to raise_error(ActiveRecord::RecordNotFound)

            end
          end

          context "floor plan in the feed already exists" do
            before do
              @plan = ApartmentFloorPlan.make(:vaultware,
                :external_cms_id     => '20294',
                :apartment_community => @community,
                :name                => 'TEST',
                :availability_url    => 'TEST',
                :bedrooms            => 99,
                :bathrooms           => 99,
                :min_square_feet     => 9999,
                :max_square_feet     => 9999,
                :min_rent            => 9999,
                :max_rent            => 9999,
                :image_url           => 'TEST',
                :floor_plan_group    => ApartmentFloorPlanGroup.studio
              )
            end

            it "only creates the new communities and floor plans" do
              expect {
                expect {
                  subject.load!
                }.to change { ApartmentCommunity.count }.by(1)
              }.to change { ApartmentFloorPlan.count }.by(2)
            end

            it "updates the existing communities and floor plans" do
              subject.load!

              @community.reload.tap do |c|
                c.core_id.should           == 123
                c.title.should             == 'The Courts of Devon'
                c.street_address.should    == '501 Main Street'
                c.city.should              == City.find_by_name('Gaithersburg')
                c.state.should             == State.find_by_code('MD')
                c.availability_url.should  == 'http://units.realtydatatrust.com/unittype.aspx?ils=5341&propid=16976'
                c.external_cms_id.should   == '16976'
                c.external_cms_type.should == 'vaultware'

                c.office_hours.first.tap do |office_hour|
                  office_hour.day.should              == 0
                  office_hour.opens_at.should         == '12:00'
                  office_hour.opens_at_period.should  == 'PM'
                  office_hour.closes_at.should        == '5:00'
                  office_hour.closes_at_period.should == 'PM'
                end

                c.office_hours.last.tap do |office_hour|
                  office_hour.day.should              == 6
                  office_hour.opens_at.should         == '10:00'
                  office_hour.opens_at_period.should  == 'AM'
                  office_hour.closes_at.should        == '5:00'
                  office_hour.closes_at_period.should == 'PM'
                end
              end

              @plan.reload.tap do |p|
                p.name.should              == '2 Bedroom/1 Bath'
                p.availability_url.should  == 'http://units.realtydatatrust.com/unitavailability.aspx?ils=5341&fid=20294'
                p.available_units.should   == 5
                p.bedrooms.should          == 2
                p.bathrooms.should         == 1
                p.min_square_feet.should   == 761
                p.max_square_feet.should   == 833
                p.min_rent.should          == 1540
                p.max_rent.should          == 1820
                p.image_url.should         == 'http://cdn.realtydatatrust.com/i/fs/62315'
                p.floor_plan_group.should  == ApartmentFloorPlanGroup.studio
                p.external_cms_id.should   == '20294'
                p.external_cms_type.should == 'vaultware'
              end
            end

            it "does not update the existing floor plan's group" do
              subject.load!

              @plan.reload

              @plan.floor_plan_group.should == ApartmentFloorPlanGroup.studio
            end
          end

          context "with a 'duplicate' property from another feed" do
            before do
              ApartmentCommunity.make(:title => 'The Courts of Devon', :core_id => 111)
            end

            it "does not change the core id" do
              subject.load!

              @community.reload.core_id.should == 123
            end
          end
        end
      end

      describe "loading a Carmel feed when there are existing Carmel properties" do
        subject do
          Bozzuto::ExternalFeed::Loader.loader_for_type(:carmel, :file => Rails.root.join('test/files/carmel.xml'))
        end

        before do
          setup_loader_stubs(subject)

          @state     = State.find_by_code('PA')
          @city      = City.make(:state => @state, name: 'Pittsburgh')
          @community = ApartmentCommunity.make(:carmel,
            :external_cms_id  => 'CHE801',
            :title            => 'TEST',
            :city             => @city,
            :street_address   => 'TEST',
            :availability_url => 'TEST'
          )
        end

        it "does not overwrite existing information" do
          subject.load!

          @community.reload.tap do |c|
            c.title.should             == 'TEST'
            c.street_address.should    == 'TEST'
            c.city.should              == @city
            c.state.should             == @state
            c.availability_url.should  == 'TEST'
            c.external_cms_id.should   == 'CHE801'
            c.external_cms_type.should == 'carmel'
            c.office_hours.should      == []
          end
        end
      end

      describe "loading a full feed" do
        Bozzuto::ExternalFeed::Feed.feed_types.each do |type|
          context "#{type}" do
            subject { Bozzuto::ExternalFeed::Loader.loader_for_type(type) }

            before do
              setup_loader_stubs(subject)

              subject.file = Rails.root.join("test/files/#{type}_full.xml")
            end

            it "doesn't raise an exception" do
              expect {
                subject.load!
              }.to_not raise_error
            end
          end
        end
      end
    end
  end
end
