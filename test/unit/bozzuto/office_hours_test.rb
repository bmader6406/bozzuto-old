require 'test_helper'

module Bozzuto
  class OfficeHoursTest < ActiveSupport::TestCase
    context "OfficeHours" do
      describe ".create_records_for" do
        before do
          @property = ApartmentCommunity.make
        end

        subject { Bozzuto::OfficeHours }

        context "when the given property has a contact page" do
          context "given pretty standard formatting" do
            before do
              @page_content = "<h2>\r\n\t<strong>Address</strong></h2>\r\n<p>\r\n\t<span style=\"font-size: 12px;\">The Fenestra Apartments<br />\r\n\t20 Maryland Avenue<br />\r\n\tRockville, MD&nbsp; 20850<br />\r\n\t&nbsp;301.279.0999</span></p>\r\n<h2>\r\n\t<strong>Office hours</strong></h2>\r\n<p>\r\n\t<span style=\"font-size: 12px;\">Monday-Thursday 9:00am-6:00pm</span></p>\r\n<p>\r\n\t<span style=\"font-size: 12px;\">Friday 8:00-5:00</span></p>\r\n<p>\r\n\t<span style=\"font-size: 12px;\">Saturday 10:00am-5:00pm</span></p>\r\n<h2>\r\n\t<span style=\"font-size: 12px;\">Sunday 12:00pm-5:00pm</span><br />\r\n\t<br />\r\n\t<br />\r\n\tLooking for answers?&nbsp; We are here to help.</h2>\r\n<p>\r\n\t<span style=\"font-size: 12px;\">We are committed to serving our customers and value your feedback.&nbsp; If you are a current resident and have a question or concern please contact us.</span></p>\r\n<p>\r\n\t&nbsp;</p>\r\n<p>\r\n\t<span style=\"font-size: 12px;\"><strong>Property Manager:</strong><br />\r\n\t<span style=\"color:#696969;\">Kelly C Jones<br />\r\n\t301-279-0999</span></span><br />\r\n\t<a href=\"mailto:kjones@bozzuto.com\"><span data-sheets-userformat=\"[null,null,2111744,null,null,null,null,null,null,null,null,0,null,null,[null,2,8684683],&quot;calibri,arial,sans,sans-serif&quot;,11,null,null,null,null,null,null,null,[null,0,3,0,3]]\" data-sheets-value=\"[null,2,&quot;kjones@bozzuto.com                                              &quot;]\" style=\"font-size:110%;font-family:calibri,arial,sans,sans-serif;color:#84848b;\">kjones@bozzuto.com</span></a></p>\r\n<p>\r\n\t&nbsp;</p>\r\n<p>\r\n\t<span style=\"font-size: 12px;\"><strong>Regional Manager:</strong></span></p>\r\n<p>\r\n\tPatrice Gorgone</p>\r\n<p>\r\n\t<span style=\"font-size: 12px;\"><a href=\"mailto:pgorgone@bozzuto.com\">pgorgone@bozzuto.com</a></span></p>\r\n<p>\r\n\t<br />\r\n\t<span style=\"font-size: 12px;\">&nbsp;</span></p>\r\n"

              @page = PropertyContactPage.create(
                :apartment_community => @property,
                :content             => @page_content
              )
            end

            it "creates the correct office hours records from the page's content" do
              expect { subject.create_records_for(@property) }.to change { @property.office_hours.count }.by(7)

              sunday    = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Sunday'] }
              monday    = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Monday'] }
              tuesday   = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Tuesday'] }
              wednesday = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Wednesday'] }
              thursday  = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Thursday'] }
              friday    = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Friday'] }
              saturday  = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Saturday'] }

              sunday.to_s.should    == 'Sunday: 12:00PM - 5:00PM'
              monday.to_s.should    == 'Monday: 9:00AM - 6:00PM'
              tuesday.to_s.should   == 'Tuesday: 9:00AM - 6:00PM'
              wednesday.to_s.should == 'Wednesday: 9:00AM - 6:00PM'
              thursday.to_s.should  == 'Thursday: 9:00AM - 6:00PM'
              friday.to_s.should    == 'Friday: 8:00AM - 5:00PM'
              saturday.to_s.should  == 'Saturday: 10:00AM - 5:00PM'
            end
          end

          context "given some wacky formatting" do
            before do
              @page_content = "<h3>\r\n\t&nbsp;</h3>\r\n<h2>\r\n\t<strong>Address</strong></h2>\r\n<p>\r\n\t<span style=\"font-size:12px;\">Halstead Dulles</span></p>\r\n<p>\r\n\t<span style=\"font-size:12px;\">13161 Fox Hunt Lane</span></p>\r\n<p>\r\n\t<span style=\"font-size:12px;\">Herndon, VA 20171</span></p>\r\n<p>\r\n\t<span style=\"font-size:12px;\"><span style=\"color: rgb(68, 68, 68); font-family: arial;\">(703)&nbsp;</span>787-0707&nbsp;</span></p>\r\n<h2>\r\n\t<strong>Office Hours</strong></h2>\r\n<p>\r\n\t<span style=\"font-size: 12px;\">Monday-Thursday: 9:<span scayt_word=\"00am-6\" scaytid=\"39\">00am-6</span>:<span scayt_word=\"00pm\" scaytid=\"40\">00pm</span><br />\r\n\tFriday: 8:<span scayt_word=\"00am-5\" scaytid=\"46\">00am-5</span>:<span scayt_word=\"00pm\" scaytid=\"42\">00pm</span><br />\r\n\tSaturday: 10:<span scayt_word=\"00am-5\" scaytid=\"47\">00am-5</span>:<span scayt_word=\"00pm\" scaytid=\"43\">00pm</span></span><br />\r\n\t<span style=\"font-size: 12px;\">Sunday: 12:<span scayt_word=\"00pm-5\" scaytid=\"48\">00pm-5</span>:<span scayt_word=\"00pm\" scaytid=\"44\">00pm</span></span></p>\r\n<h2>\r\n\t<strong>Directions</strong></h2>\r\n<p>\r\n\t<span style=\"font-size:12px;\">From I 495:<br />\r\n\tTake Dulles Toll Road (Route 267) West to Exit 10 (Herndon/Chantilly).<br />\r\n\tMake a Left onto Centreville Road.<br />\r\n\tGo to 2nd stoplight and make a left onto Sunrise Valley Dr.<br />\r\n\tMake a Right onto Fox Mill Lane.<br />\r\n\tMake a Left onto Fox Hunt Lane into Halstead Dulles Leasing Center</span><br />\r\n\t&nbsp;</p>\r\n<h2>\r\n\t<strong>Looking for answers?&nbsp; We are here to help.</strong></h2>\r\n<p>\r\n\t<span style=\"font-size: 12px;\">We are committed to serving our customers and value your feedback.&nbsp; If you are a current resident and have a question or concern please contact us.</span></p>\r\n<p>\r\n\t&nbsp;</p>\r\n<p>\r\n\t<span style=\"font-size: 12px;\"><strong>Property Manager:&nbsp;</strong></span></p>\r\n<p>\r\n\t<span style=\"font-size: 12px;\">Sarah Pelletier<br />\r\n\t<a href=\"mailto:spelletier@bozzuto.com\">spelletier@bozzuto.com</a></span></p>\r\n<p>\r\n\t&nbsp;</p>\r\n<p>\r\n\t<span style=\"font-size: 12px;\"><strong>Regional Portfolio Manager:</strong></span></p>\r\n<p>\r\n\t<span style=\"font-size: 12px;\">Jo Gavigan</span></p>\r\n<p>\r\n\t<span style=\"font-size: 12px;\"><a href=\"mailto:ckalinsky@bozzuto.com\">jgavigan@bozzuto.com</a></span></p>\r\n"

              @page = PropertyContactPage.create(
                :apartment_community => @property,
                :content             => @page_content
              )
            end

            it "creates the correct office hours records from the page's content" do
              expect { subject.create_records_for(@property) }.to change { @property.office_hours.count }.by(7)

              sunday    = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Sunday'] }
              monday    = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Monday'] }
              tuesday   = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Tuesday'] }
              wednesday = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Wednesday'] }
              thursday  = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Thursday'] }
              friday    = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Friday'] }
              saturday  = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Saturday'] }

              sunday.to_s.should    == 'Sunday: 12:00PM - 5:00PM'
              monday.to_s.should    == 'Monday: 9:00AM - 6:00PM'
              tuesday.to_s.should   == 'Tuesday: 9:00AM - 6:00PM'
              wednesday.to_s.should == 'Wednesday: 9:00AM - 6:00PM'
              thursday.to_s.should  == 'Thursday: 9:00AM - 6:00PM'
              friday.to_s.should    == 'Friday: 8:00AM - 5:00PM'
              saturday.to_s.should  == 'Saturday: 10:00AM - 5:00PM'
            end
          end
        end

        context "when the given property does not have a contact page" do
          context "but has existing serialized office hours" do
            before do
              @property = ApartmentCommunity.make
              @property.send(:write_attribute, :office_hours,
                [
                  { :open_time => "09:00:00 AM", :close_time => "07:00:00 PM", :day => "M" },
                  { :open_time => "09:00:00 AM", :close_time => "07:00:00 PM", :day => "T" },
                  { :open_time => "09:00:00 AM", :close_time => "07:00:00 PM", :day => "W" },
                  { :open_time => "09:00:00 AM", :close_time => "07:00:00 PM", :day => "Th" },
                  { :open_time => "08:00:00 AM", :close_time => "05:00:00 PM", :day => "F" },
                  { :open_time => "10:00:00 AM", :close_time => "05:00:00 PM", :day => "Sa" },
                  { :open_time => "12:00:00 PM", :close_time => "05:00:00 PM", :day => "Su" }
                ]
              )
            end

            it "creates the correct office hours records from the serialized office hours" do
              expect { subject.create_records_for(@property) }.to change { @property.office_hours.count }.by(7)

              sunday    = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Sunday'] }
              monday    = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Monday'] }
              tuesday   = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Tuesday'] }
              wednesday = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Wednesday'] }
              thursday  = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Thursday'] }
              friday    = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Friday'] }
              saturday  = @property.office_hours.to_a.find { |o| o.day == Bozzuto::OfficeHours::DAY_MAPPING['Saturday'] }

              sunday.to_s.should    == 'Sunday: 12:00PM - 5:00PM'
              monday.to_s.should    == 'Monday: 9:00AM - 7:00PM'
              tuesday.to_s.should   == 'Tuesday: 9:00AM - 7:00PM'
              wednesday.to_s.should == 'Wednesday: 9:00AM - 7:00PM'
              thursday.to_s.should  == 'Thursday: 9:00AM - 7:00PM'
              friday.to_s.should    == 'Friday: 8:00AM - 5:00PM'
              saturday.to_s.should  == 'Saturday: 10:00AM - 5:00PM'
            end
          end
        end
      end
    end
  end
end
