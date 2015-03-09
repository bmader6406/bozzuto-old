require 'test_helper'

module Bozzuto
  class PageContentDoctorTest < ActiveSupport::TestCase
    context "A Page Content Doctor" do
      describe "#preview?" do
        context "on a newly created doctor" do
          subject { Bozzuto::PageContentDoctor.new('page') }

          it "returns false" do
            subject.preview?.should == false
          end
        end

        context "when preview is set to true" do
          subject { Bozzuto::PageContentDoctor.new('page', :preview => true) }

          it "returns true" do
            subject.preview?.should == true
          end
        end

        context "when the preview is set to false" do
          subject { Bozzuto::PageContentDoctor.new('page', :preview => false) }

          it "returns false" do
            subject.preview?.should == false
          end
        end
      end

      describe "#preview" do
        subject { Bozzuto::PageContentDoctor.new('page', :preview => false) }

        it "sets the doctor to preview state" do
          subject.preview

          subject.preview?.should == true
        end
      end

      describe "#execute" do
        subject { Bozzuto::PageContentDoctor.new('page', :preview => true) }

        it "sets the doctor to a live state" do
          subject.execute

          subject.preview?.should == false
        end
      end

      describe "#content" do
        subject do
          Bozzuto::PageContentDoctor.new Page.new('content')
        end

        it "returns the content" do
          subject.content.should == 'content'
        end

        context "given a custom content method" do
          subject do
            Bozzuto::PageContentDoctor.new(
              NonStandardPage.new('content'), :content_method => :body
            )
          end

          it "returns the content" do
            subject.content.should == 'content'
          end
        end
      end

      describe "#trim_address_phone_and_office_hours" do
        before do
          @page_content = "<h2>\r\n\t<strong>Address</strong></h2>\r\n<div itemscope=\"\" itemtype=\"http://schema.org/LocalBusiness\">\r\n\t<div itemscope=\"\" itemtype=\"http://schema.org/ApartmentComplex\">\r\n\t\t<span itemprop=\"name\" style=\"font-size: 12px;\">100 Park at Wyomissing Square</span></div>\r\n\t<div itemprop=\"address\" itemscope=\"\" itemtype=\"http://schema.org/PostalAddress\">\r\n\t\t<span itemprop=\"streetAddress\" style=\"font-size: 12px;\">100 N. Park Rd. Ste. 2000</span> <span itemprop=\"addressLocality\" style=\"font-size: 12px;\">Wyomissing</span>, <span itemprop=\"addressRegion\" style=\"font-size: 12px;\">PA</span> <span itemprop=\"postalCode\" style=\"font-size: 12px;\">19610</span></div>\r\n\t<div itemprop=\"address\" itemscope=\"\" itemtype=\"http://schema.org/PostalAddress\">\r\n\t\t&nbsp;</div>\r\n\t<div itemprop=\"address\" itemscope=\"\" itemtype=\"http://schema.org/PostalAddress\">\r\n\t\t<span itemprop=\"postalCode\" style=\"font-size: 12px;\">866.307.6180</span></div>\r\n\t<h2>\r\n\t\t<strong>Office Hours</strong></h2>\r\n\t<p>\r\n\t\t<span content=\"Mo 09:00-18:00\" itemprop=\"openingHours\" style=\"font-size: 12px;\">Monday 9:00am-6:00pm</span><br />\r\n\t\t<span content=\"Tu 09:00-18:00\" itemprop=\"openingHours\" style=\"font-size: 12px;\">Tuesday 9:00am-6:00pm</span><br />\r\n\t\t<span content=\"We 09:00-18:00\" itemprop=\"openingHours\" style=\"font-size: 12px;\">Wednesday 9:00am-6:00pm</span><br />\r\n\t\t<span content=\"Th 09:00-18:00\" itemprop=\"openingHours\" style=\"font-size: 12px;\">Thursday 9:00am-6:00pm</span><br />\r\n\t\t<span content=\"Fr 08:00-17:00\" itemprop=\"openingHours\" style=\"font-size: 12px;\">Friday 8:00am-5:00pm</span><br />\r\n\t\t<span content=\"Sa 10:00-17:00\" itemprop=\"openingHours\" style=\"font-size: 12px;\">Saturday 10:00am-5:00pm</span><br />\r\n\t\t<span content=\"Su 12:00-17:00\" itemprop=\"openingHours\" style=\"font-size: 12px;\">Sunday 12:00pm-5:00pm</span></p>\r\n\t<p>\r\n\t\t&nbsp;</p>\r\n\t<h2>\r\n\t\t<strong>Looking for answers?&nbsp; We are here to help.</strong></h2>\r\n\t<p>\r\n\t\t<span style=\"font-size: 12px;\">We are committed to serving our customers and value your feedback.&nbsp; If you are a current resident and have a question or concern please contact us. </span></p>\r\n\t<p>\r\n\t\t&nbsp;</p>\r\n\t<p>\r\n\t\t<strong><span style=\"font-size: 12px;\">Property Manager: </span></strong></p>\r\n\t<p>\r\n\t\t<span style=\"font-size: 12px;\">Piera Moyer<br />\r\n\t\t484.638.6950<br />\r\n\t\t<a href=\"mailto:pmoyer@bozzuto.com\">pmoyer@bozzuto.com</a></span></p>\r\n\t<p>\r\n\t\t&nbsp;</p>\r\n\t<p>\r\n\t\t<strong><span style=\"font-size: 12px;\">Regional Vice President:</span></strong></p>\r\n\t<p>\r\n\t\t<span style=\"font-size: 12px;\">Michele Kearney</span><br />\r\n\t\t<a href=\"mailto:mkearney@bozzuto.com\">mkearney@bozzuto.com</a></p>\r\n</div>\r\n<p>\r\n\t&nbsp;</p>\r\n"

          @persisting_content = "<h2>\r\n\t\t<strong>Looking for answers?&nbsp; We are here to help.</strong></h2>\r\n\t<p>\r\n\t\t<span style=\"font-size: 12px;\">We are committed to serving our customers and value your feedback.&nbsp; If you are a current resident and have a question or concern please contact us. </span></p>\r\n\t<p>\r\n\t\t&nbsp;</p>\r\n\t<p>\r\n\t\t<strong><span style=\"font-size: 12px;\">Property Manager: </span></strong></p>\r\n\t<p>\r\n\t\t<span style=\"font-size: 12px;\">Piera Moyer<br />\r\n\t\t484.638.6950<br />\r\n\t\t<a href=\"mailto:pmoyer@bozzuto.com\">pmoyer@bozzuto.com</a></span></p>\r\n\t<p>\r\n\t\t&nbsp;</p>\r\n\t<p>\r\n\t\t<strong><span style=\"font-size: 12px;\">Regional Vice President:</span></strong></p>\r\n\t<p>\r\n\t\t<span style=\"font-size: 12px;\">Michele Kearney</span><br />\r\n\t\t<a href=\"mailto:mkearney@bozzuto.com\">mkearney@bozzuto.com</a></p>\r\n</div>\r\n<p>\r\n\t&nbsp;</p>\r\n"

          @page = Page.new(@page_content)
        end

        subject { Bozzuto::PageContentDoctor.new(@page) }

        context "when in preview-mode" do
          before { subject.preview }

          it "returns the doctored content" do
            subject.trim_address_phone_and_office_hours.should == @persisting_content
          end

          it "does not modify the page's original content" do
            subject.trim_address_phone_and_office_hours

            @page.content.should == @page_content
          end
        end

        context "when not in execute-mode" do
          it "returns the doctored content" do
            subject.execute.trim_address_phone_and_office_hours.should == @persisting_content
          end

          it "modifies the page's original content" do
            subject.execute.trim_address_phone_and_office_hours

            @page.content.should == @persisting_content
          end
        end

        context "given a page with non-standard content" do
          before do
            @nonstandard_content = "<h2>\r\n\tAddress</h2>\r\n<p>\r\n\t13611 Ale House Circle<br />\r\n\tGermantown, MD 20874</p>\r\n<h2>\r\n\t<span style=\"font-size:12px;\"><strong>Office Hours</strong></span></h2>\r\n<p>\r\n\t<span style=\"font-size:12px;\">Monday: 9am-6pm<br />\r\n\tTuesday: 8am-6pm<br />\r\n\tWednesday: 8am-6pm<br />\r\n\tThursday: 9am-6pm<br />\r\n\tFriday: 8am-5pm<br />\r\n\tSaturday: 10am-5pm<br />\r\n\tSunday: noon-5pm</span><br />\r\n\t&nbsp;</p>\r\n<p>\r\n\t<span style=\"font-size:12px;\"><strong>Regional Manager</strong></span></p>\r\n<p>\r\n\tLexie Greany</p>\r\n<p>\r\n\t<a href=\"mailto:lgreany@bozzuto.com\">lgreany@bozzuto.com</a></p>\r\n<p>\r\n\t<span style=\"font-size:12px;\"><strong>Property Manager</strong></span></p>\r\n<p>\r\n\tCarly Greer</p>\r\n<p>\r\n\t<a href=\"mailto:cgreer@bozzuto.com\">cgreer@bozzuto.com</a></p>\r\n<p>\r\n\t&nbsp;</p>\r\n"

            @page = Page.new(@nonstandard_content)
          end

          subject { Bozzuto::PageContentDoctor.new(@page) }

          it "returns the original content" do
            subject.trim_address_phone_and_office_hours.should == @nonstandard_content
          end
        end
      end
    end

    private

    class Page < Struct.new(:content)
      def update_attributes(input)
        input.each { |attr, value| send("#{attr}=", value) }
      end
    end

    NonStandardPage = Struct.new(:body)
  end
end
