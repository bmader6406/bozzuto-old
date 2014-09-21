require 'test_helper'

class BozzutoSiteSearchSearchTest < ActiveSupport::TestCase
  context "A Search" do
    describe "#page" do
      subject { Bozzuto::SiteSearch::Search.new('batman') }

      before do
        subject.stubs(:yboss).returns(stub(:start => 60, :count => 30))
      end

      it "returns the correct page number" do
        subject.page.should == 3
      end
    end

    describe "#total_pages" do
      subject { Bozzuto::SiteSearch::Search.new('batman') }

      before do
        subject.stubs(:yboss).returns(stub(:totalresults => 250, :count => 20))
      end

      it "returns the correct page number" do
        subject.total_pages.should == 13
      end
    end

    describe "#first_result_num" do
      subject { Bozzuto::SiteSearch::Search.new('batman') }

      before do
        subject.stubs(:yboss).returns(stub(:start => 25))
      end

      it "returns the correct page number" do
        subject.first_result_num.should == 26
      end
    end

    describe "#last_result_num" do
      subject { Bozzuto::SiteSearch::Search.new('batman') }

      before do
        subject.stubs(:yboss).returns(stub(:start => 25, :count => 25))
      end

      it "returns the correct page number" do
        subject.last_result_num.should == 50
      end
    end

    describe "#results" do
      subject { Bozzuto::SiteSearch::Search.new('carmel') }

      it "returns the results" do
        VCR.use_cassette('boss_search_carmel', :match_requests_on => [:method, :host, :path]) do
          subject.results
        end

        subject.start.should == 0
        subject.per_page.should == 20
        subject.page.should == 1
        subject.total_pages.should == 3
        subject.first_result_num.should == 1
        subject.last_result_num.should == 20
        subject.results.count.should == 20
      end
    end
  end
end
