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

        context "loading a feed with units, unit-level amenities, and unit-level files" do
          subject do
            Bozzuto::ExternalFeed::Loader.loader_for_type(:rent_cafe, :file => Rails.root.join('test/files/rent_cafe.xml'))
          end

          before do
            setup_loader_stubs(subject)
          end

          it "creates the community, floor plans, units, unit-level amenities, and unit-level files" do
            counts = [
              ApartmentCommunity.count,
              ApartmentFloorPlan.count,
              ::ApartmentUnit.count,
              ::ApartmentUnitAmenity.count,
              FeedFile.count
            ]

            counts.all?(&:zero?).should == true

            subject.load!

            ApartmentCommunity.count.should     == 2
            ApartmentFloorPlan.count.should     == 3
            ::ApartmentUnit.count.should        == 4
            ::ApartmentUnitAmenity.count.should == 8
            FeedFile.count.should               == 6

            ::ApartmentCommunity.first.tap do |c|
              c.title.should             == 'Madox'
              c.street_address.should    == '198 Van Vorst Street'
              c.city.should              == City.find_by_name('Jersey City')
              c.state.should             == State.find_by_code('NJ')
              c.availability_url.should  == 'http://madoxapts.securecafe.com/onlineleasing/madox/oleapplication.aspx?stepname=Apartments&myOlePropertyId=111537'
              c.external_cms_id.should   == 'p0117760'
              c.external_cms_type.should == 'rent_cafe'

              c.office_hours.first.tap do |office_hour|
                office_hour.day.should              == 1
                office_hour.opens_at.should         == '9:00'
                office_hour.opens_at_period.should  == 'AM'
                office_hour.closes_at.should        == '6:00'
                office_hour.closes_at_period.should == 'PM'
              end

              c.office_hours.last.tap do |office_hour|
                office_hour.day.should              == 6
                office_hour.opens_at.should         == '10:00'
                office_hour.opens_at_period.should  == 'AM'
                office_hour.closes_at.should        == '5:00'
                office_hour.closes_at_period.should == 'PM'
              end

              c.floor_plans.count.should == 2

              c.floor_plans.first.tap do |f|
                f.name.should              == 'A1-2'
                f.availability_url.should  == 'http://madoxapts.securecafe.com/onlineleasing/madox/oleapplication.aspx?stepname=Apartments&myOlePropertyId=111537&floorPlans=858901'
                f.available_units.should   == 0
                f.bedrooms.should          == 1
                f.bathrooms.should         == 1
                f.min_square_feet.should   == 735
                f.max_square_feet.should   == 735
                f.min_rent.should          == 2589
                f.max_rent.should          == 3216
                f.image_url.should         == 'http://www.rentcafe.com/dmslivecafe/3/111537/111537_2_1_81755.jpg'
                f.floor_plan_group.should  == ApartmentFloorPlanGroup.one_bedroom
                f.external_cms_id.should   == '858901'
                f.external_cms_type.should == 'rent_cafe'

                f.apartment_units.count.should == 2

                f.apartment_units.first.tap do |u|
                  u.external_cms_id.should              == '605'
                  u.external_cms_type.should            == 'rent_cafe'
                  u.building_external_cms_id.should     == '49741'
                  u.floorplan_external_cms_id.should    == '858901'
                  u.organization_name.should            == nil
                  u.marketing_name.should               == nil
                  u.unit_type.should                    == '297-3752'
                  u.bedrooms.should                     == 1
                  u.bathrooms.should                    == 1
                  u.min_square_feet.should              == 665
                  u.max_square_feet.should              == 665
                  u.square_foot_type.should             == 'Internal'
                  u.unit_rent.should                    == 2318
                  u.market_rent.should                  == 2604
                  u.economic_status.should              == 'residential'
                  u.economic_status_description.should  == 'residential'
                  u.occupancy_status.should             == 'Occupied No Notice'
                  u.occupancy_status_description.should == nil
                  u.leased_status.should                == 'Occupied No Notice'
                  u.leased_status_description.should    == 'Occupied No Notice'
                  u.number_occupants.should             == nil
                  u.floor_plan_name.should              == 'A3-2'
                  u.phase_name.should                   == nil
                  u.building_name.should                == nil
                  u.primary_property_id.should          == '111537'
                  u.address_line_1.should               == nil
                  u.address_line_2.should               == nil
                  u.city.should                         == nil
                  u.state.should                        == nil
                  u.zip.should                          == nil
                  u.avg_rent.should                     == nil
                  u.min_rent.should                     == nil
                  u.max_rent.should                     == nil
                  u.comment.should                      == nil
                  u.vacate_date.should                  == nil
                  u.vacancy_class.should                == nil
                  u.made_ready_date.should              == nil
                  u.availability_url.should             == CGI.unescapeHTML("http://madoxapts.securecafe.com/onlineleasing/madox/oleapplication.aspx?stepname=RentalOptions&amp;myOlePropertyId=111537&amp;header=1&amp;FloorPlanID=858907&amp;UnitID=708798")

                  u.amenities.count.should == 3

                  u.amenities[0].tap do |amenity|
                    amenity.primary_type.should == 'Other'
                    amenity.description.should  == '6th Floor'
                  end

                  u.amenities[1].tap do |amenity|
                    amenity.primary_type.should == 'Other'
                    amenity.description.should  == 'Courtyard View'
                  end

                  u.amenities[2].tap do |amenity|
                    amenity.primary_type.should == 'Other'
                    amenity.description.should  == 'Rent'
                  end

                  u.feed_files.count.should == 1

                  u.feed_files.first.tap do |file|
                    file.external_cms_id.should   == '605'
                    file.external_cms_type.should == 'rent_cafe'
                    file.active.should            == true
                    file.file_type.should         == 'Other'
                    file.description.should       == ''
                    file.name.should              == '3_340120_1833937'
                    file.caption.should           == ''
                    file.format.should            == 'image/jpeg'
                    file.source.should            == 'http://cdn.rentcafe.com/dmslivecafe/3/340670/3_340120_1833937.jpg'
                    file.width.should             == 0
                    file.height.should            == 0
                    file.rank.should              == '3'
                    file.ad_id.should             == ''
                    file.affiliate_id.should      == ''
                  end
                end

                f.apartment_units.last.tap do |u|
                  u.external_cms_id.should              == '521'
                  u.external_cms_type.should            == 'rent_cafe'
                  u.building_external_cms_id.should     == '49734'
                  u.floorplan_external_cms_id.should    == '858901'
                  u.organization_name.should            == nil
                  u.marketing_name.should               == nil
                  u.unit_type.should                    == '297-3782'
                  u.bedrooms.should                     == 0
                  u.bathrooms.should                    == 1
                  u.min_square_feet.should              == 480
                  u.max_square_feet.should              == 480
                  u.square_foot_type.should             == 'Internal'
                  u.unit_rent.should                    == 2047
                  u.market_rent.should                  == 2047
                  u.economic_status.should              == 'residential'
                  u.economic_status_description.should  == 'residential'
                  u.occupancy_status.should             == 'Occupied No Notice'
                  u.occupancy_status_description.should == nil
                  u.leased_status.should                == 'Occupied No Notice'
                  u.leased_status_description.should    == 'Occupied No Notice'
                  u.number_occupants.should             == nil
                  u.floor_plan_name.should              == 'A0'
                  u.phase_name.should                   == nil
                  u.building_name.should                == nil
                  u.primary_property_id.should          == '111537'
                  u.address_line_1.should               == nil
                  u.address_line_2.should               == nil
                  u.city.should                         == nil
                  u.state.should                        == nil
                  u.zip.should                          == nil
                  u.avg_rent.should                     == nil
                  u.min_rent.should                     == nil
                  u.max_rent.should                     == nil
                  u.comment.should                      == nil
                  u.vacate_date.should                  == nil
                  u.vacancy_class.should                == nil
                  u.made_ready_date.should              == nil
                  u.availability_url.should             == CGI.unescapeHTML("http://madoxapts.securecafe.com/onlineleasing/madox/oleapplication.aspx?stepname=RentalOptions&amp;myOlePropertyId=111537&amp;header=1&amp;FloorPlanID=858903&amp;UnitID=708791")

                  u.amenities.count.should == 2

                  u.amenities.first.tap do |amenity|
                    amenity.primary_type.should == 'Other'
                    amenity.description.should  == '5th Floor'
                  end

                  u.amenities.last.tap do |amenity|
                    amenity.primary_type.should == 'Other'
                    amenity.description.should  == 'Rent'
                  end

                  u.feed_files.count.should == 2

                  u.feed_files.first.tap do |file|
                    file.external_cms_id.should   == '521'
                    file.external_cms_type.should == 'rent_cafe'
                    file.active.should            == true
                    file.file_type.should         == 'Other'
                    file.description.should       == ''
                    file.name.should              == '3_345611_1385175'
                    file.caption.should           == ''
                    file.format.should            == 'image/jpeg'
                    file.source.should            == 'http://cdn.rentcafe.com/dmslivecafe/3/340670/3_345611_1385175.jpg'
                    file.width.should             == 0
                    file.height.should            == 0
                    file.rank.should              == '4'
                    file.ad_id.should             == ''
                    file.affiliate_id.should      == ''
                  end

                  u.feed_files.last.tap do |file|
                    file.external_cms_id.should   == '521'
                    file.external_cms_type.should == 'rent_cafe'
                    file.active.should            == true
                    file.file_type.should         == 'Photo'
                    file.description.should       == ''
                    file.name.should              == '3_121387_1218990'
                    file.caption.should           == ''
                    file.format.should            == 'image/jpeg'
                    file.source.should            == 'http://cdn.rentcafe.com/dmslivecafe/3/111537/3_121387_1218990.jpg'
                    file.width.should             == 0
                    file.height.should            == 0
                    file.rank.should              == '9'
                    file.ad_id.should             == ''
                    file.affiliate_id.should      == ''
                  end
                end
              end

              c.floor_plans.last.tap do |f|
                f.name.should              == 'B3-2'
                f.availability_url.should  == 'http://madoxapts.securecafe.com/onlineleasing/madox/oleapplication.aspx?stepname=Apartments&myOlePropertyId=111537&floorPlans=858902'
                f.available_units.should   == 1
                f.bedrooms.should          == 2
                f.bathrooms.should         == 2
                f.min_square_feet.should   == 1057
                f.max_square_feet.should   == 1057
                f.min_rent.should          == 3875
                f.max_rent.should          == 5040
                f.image_url.should         == 'http://www.rentcafe.com/dmslivecafe/3/111537/111537_2_1_81757.jpg'
                f.floor_plan_group.should  == ApartmentFloorPlanGroup.two_bedrooms
                f.external_cms_id.should   == '858902'
                f.external_cms_type.should == 'rent_cafe'
              end

            end

            ::ApartmentCommunity.last.tap do |c|
              c.title.should             == 'The Brownstones at Englewood South'
              c.street_address.should    == '73 Brownstone Way'
              c.city.should              == City.find_by_name('Englewood')
              c.state.should             == State.find_by_code('NJ')
              c.availability_url.should  == 'http://liveatbrownstones.securecafe.com/onlineleasing/the-brownstones-at-englewood-south/oleapplication.aspx?stepname=Apartments&myOlePropertyId=144341'
              c.external_cms_id.should   == 'p0151017'
              c.external_cms_type.should == 'rent_cafe'

              c.office_hours.first.tap do |office_hour|
                office_hour.day.should              == 0
                office_hour.opens_at.should         == '12:00'
                office_hour.opens_at_period.should  == 'PM'
                office_hour.closes_at.should        == '5:00'
                office_hour.closes_at_period.should == 'PM'
              end

              c.floor_plans.count.should == 1

              c.floor_plans.first.tap do |f|
                f.name.should              == 'One Bedroom / One Bath - A1'
                f.availability_url.should  == 'http://liveatbrownstones.securecafe.com/onlineleasing/the-brownstones-at-englewood-south/oleapplication.aspx?stepname=Apartments&myOlePropertyId=144341&floorPlans=937747'
                f.available_units.should   == 3
                f.bedrooms.should          == 1
                f.bathrooms.should         == 1
                f.min_square_feet.should   == 788
                f.max_square_feet.should   == 788
                f.min_rent.should          == 2098
                f.max_rent.should          == 3453
                f.image_url.should         == nil
                f.floor_plan_group.should  == ApartmentFloorPlanGroup.one_bedroom
                f.external_cms_id.should   == '937747'
                f.external_cms_type.should == 'rent_cafe'

                f.apartment_units.count.should == 2

                f.apartment_units.first.tap do |u|
                  u.external_cms_id.should              == '09-207'
                  u.external_cms_type.should            == 'rent_cafe'
                  u.building_external_cms_id.should     == '24613'
                  u.floorplan_external_cms_id.should    == '937747'
                  u.organization_name.should            == nil
                  u.marketing_name.should               == nil
                  u.unit_type.should                    == '297-1562'
                  u.bedrooms.should                     == 1
                  u.bathrooms.should                    == 1
                  u.min_square_feet.should              == 788
                  u.max_square_feet.should              == 788
                  u.square_foot_type.should             == 'Internal'
                  u.unit_rent.should                    == 1828
                  u.market_rent.should                  == 1813
                  u.economic_status.should              == 'residential'
                  u.economic_status_description.should  == 'residential'
                  u.occupancy_status.should             == 'Vacant'
                  u.occupancy_status_description.should == nil
                  u.leased_status.should                == 'available'
                  u.leased_status_description.should    == 'Occupied No Notice'
                  u.number_occupants.should             == nil
                  u.floor_plan_name.should              == 'One Bedroom / One Bath - A1'
                  u.phase_name.should                   == nil
                  u.building_name.should                == nil
                  u.primary_property_id.should          == '144341'
                  u.address_line_1.should               == nil
                  u.address_line_2.should               == nil
                  u.city.should                         == nil
                  u.state.should                        == nil
                  u.zip.should                          == nil
                  u.avg_rent.should                     == nil
                  u.min_rent.should                     == nil
                  u.max_rent.should                     == nil
                  u.comment.should                      == nil
                  u.vacate_date.should                  == nil
                  u.vacancy_class.should                == nil
                  u.made_ready_date.should              == nil
                  u.availability_url.should             == CGI.unescapeHTML("http://liveatbrownstones.securecafe.com/onlineleasing/the-brownstones-at-englewood-south/oleapplication.aspx?stepname=RentalOptions&amp;myOlePropertyId=144341&amp;header=1&amp;FloorPlanID=937747&amp;UnitID=1230276")

                  u.amenities.count.should == 1

                  u.amenities.first.tap do |amenity|
                    amenity.primary_type.should == 'Other'
                    amenity.description.should  == 'Rent'
                  end

                  u.feed_files.count.should == 2

                  u.feed_files.first.tap do |file|
                    file.external_cms_id.should   == '09-207'
                    file.external_cms_type.should == 'rent_cafe'
                    file.active.should            == true
                    file.file_type.should         == 'Other'
                    file.description.should       == ''
                    file.name.should              == '3_340670_1885137'
                    file.caption.should           == ''
                    file.format.should            == 'image/jpeg'
                    file.source.should            == 'http://cdn.rentcafe.com/dmslivecafe/3/340670/3_340670_1885137.jpg'
                    file.width.should             == 0
                    file.height.should            == 0
                    file.rank.should              == '3'
                    file.ad_id.should             == ''
                    file.affiliate_id.should      == ''
                  end

                  u.feed_files.last.tap do |file|
                    file.external_cms_id.should   == '09-207'
                    file.external_cms_type.should == 'rent_cafe'
                    file.active.should            == true
                    file.file_type.should         == 'Other'
                    file.description.should       == ''
                    file.name.should              == '3_340670_1885141'
                    file.caption.should           == ''
                    file.format.should            == 'image/jpeg'
                    file.source.should            == 'http://cdn.rentcafe.com/dmslivecafe/3/340670/3_340670_1885141.jpg'
                    file.width.should             == 0
                    file.height.should            == 0
                    file.rank.should              == '4'
                    file.ad_id.should             == ''
                    file.affiliate_id.should      == ''
                  end
                end

                f.apartment_units.last.tap do |u|
                  u.external_cms_id.should              == '09-209'
                  u.external_cms_type.should            == 'rent_cafe'
                  u.building_external_cms_id.should     == '24614'
                  u.floorplan_external_cms_id.should    == '937747'
                  u.organization_name.should            == nil
                  u.marketing_name.should               == nil
                  u.unit_type.should                    == '297-1562'
                  u.bedrooms.should                     == 1
                  u.bathrooms.should                    == 1
                  u.min_square_feet.should              == 788
                  u.max_square_feet.should              == 788
                  u.square_foot_type.should             == 'Internal'
                  u.unit_rent.should                    == 1592
                  u.market_rent.should                  == 1828
                  u.economic_status.should              == 'residential'
                  u.economic_status_description.should  == 'residential'
                  u.occupancy_status.should             == 'Vacant'
                  u.occupancy_status_description.should == nil
                  u.leased_status.should                == 'available'
                  u.leased_status_description.should    == 'Occupied No Notice'
                  u.number_occupants.should             == nil
                  u.floor_plan_name.should              == 'One Bedroom / One Bath - A1'
                  u.phase_name.should                   == nil
                  u.building_name.should                == nil
                  u.primary_property_id.should          == '144341'
                  u.address_line_1.should               == nil
                  u.address_line_2.should               == nil
                  u.city.should                         == nil
                  u.state.should                        == nil
                  u.zip.should                          == nil
                  u.avg_rent.should                     == nil
                  u.min_rent.should                     == nil
                  u.max_rent.should                     == nil
                  u.comment.should                      == nil
                  u.vacate_date.should                  == nil
                  u.vacancy_class.should                == nil
                  u.made_ready_date.should              == nil
                  u.availability_url.should             == CGI.unescapeHTML("http://liveatbrownstones.securecafe.com/onlineleasing/the-brownstones-at-englewood-south/oleapplication.aspx?stepname=RentalOptions&amp;myOlePropertyId=144341&amp;header=1&amp;FloorPlanID=937747&amp;UnitID=1230277")

                  u.amenities.count.should == 2

                  u.amenities.first.tap do |amenity|
                    amenity.primary_type.should == 'Other'
                    amenity.description.should  == 'New Kitchen Countertops'
                  end

                  u.amenities.last.tap do |amenity|
                    amenity.primary_type.should == 'Other'
                    amenity.description.should  == 'Rent'
                  end

                  u.feed_files.count.should == 1

                  u.feed_files.first.tap do |file|
                    file.external_cms_id.should   == '09-209'
                    file.external_cms_type.should == 'rent_cafe'
                    file.active.should            == true
                    file.file_type.should         == 'Photo'
                    file.description.should       == ''
                    file.name.should              == '3_111537_1778084'
                    file.caption.should           == ''
                    file.format.should            == 'image/jpeg'
                    file.source.should            == 'http://cdn.rentcafe.com/dmslivecafe/3/111537/3_111537_1778084.jpg'
                    file.width.should             == 0
                    file.height.should            == 0
                    file.rank.should              == '9'
                    file.ad_id.should             == ''
                    file.affiliate_id.should      == ''
                  end
                end
              end
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
