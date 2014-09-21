require 'test_helper'

class BozzutoSiteSearchSearchParamsTest < ActiveSupport::TestCase
  context "Search Params" do
    describe "#to_yboss_params" do
      subject do
        Bozzuto::SiteSearch::SearchParams.new(
          :q        => 'batman',
          :sites    => 'wayneindustries.com',
          :page     => 3,
          :per_page => 100
        )
      end

      it "returns the params" do
        subject.to_yboss_params.should == {
          :q     => 'batman',
          :sites => 'wayneindustries.com',
          :start => '200',
          :count => '100'
        }
      end
    end

    describe "#query" do
      subject { Bozzuto::SiteSearch::SearchParams.new(:q => 'batman') }

      it "returns the q param" do
        subject.query.should == 'batman'
      end
    end

    describe "#sites" do
      subject { Bozzuto::SiteSearch::SearchParams.new(:sites => 'wayneindustries.com') }

      it "returns the sites param" do
        subject.sites.should == 'wayneindustries.com'
      end
    end

    describe "#start" do
      subject { Bozzuto::SiteSearch::SearchParams.new(:page => 3, :per_page => 25) }

      it "returns the correct starting position" do
        subject.start.should == 50
      end
    end

    describe "#page" do
      context "value is at least 1" do
        subject { Bozzuto::SiteSearch::SearchParams.new(:page => '5') }

        it "returns the value as an int" do
          subject.page.should == 5
        end
      end

      context "value is less than 1" do
        subject { Bozzuto::SiteSearch::SearchParams.new(:per_page => '0') }

        it "returns 1" do
          subject.page.should == 1
        end
      end
    end

    describe "#per_page" do
      context "value is at least 20" do
        subject { Bozzuto::SiteSearch::SearchParams.new(:per_page => '35') }

        it "returns the value as an int" do
          subject.per_page.should == 35
        end
      end

      context "value is less than 20" do
        subject { Bozzuto::SiteSearch::SearchParams.new(:per_page => '5') }

        it "returns 20" do
          subject.per_page.should == 20
        end
      end
    end
  end
end
