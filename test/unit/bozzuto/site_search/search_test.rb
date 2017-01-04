require 'test_helper'

class BozzutoSiteSearchSearchTest < ActiveSupport::TestCase
  context "Bozzuto::SiteSearch::Search" do
    subject { Bozzuto::SiteSearch::Search.new('halstead') }

    before do
      @boom  = ApartmentCommunity.make(title: 'Halstead I')
      @shaka = ApartmentCommunity.make(title: 'Halstead II')
      @laka  = ApartmentCommunity.make(title: 'Apartments at Halstead')
    end

    describe "#results" do
      it "returns the records matching the given query string" do
        subject.results.should eq [@laka, @boom, @shaka]
      end
    end

    describe "#page" do
      it "returns the correct page number" do
        subject.page.should == 1
      end
    end

    describe "#total_count" do
      it "returns the total count of results" do
        subject.total_count.should == 3
      end
    end

    describe "#first_result_num" do
      it "returns the position of the first result on the given page" do
        subject.first_result_num.should == 1
      end
    end

    describe "#last_result_num" do
      it "returns the position of the last result on the given page" do
        subject.last_result_num.should == 3
      end
    end
  end
end
