require 'test_helper'

class Bozzuto::HyLyTest < ActiveSupport::TestCase
  context "Bozzuto::HyLy" do
    describe ".pid_for" do
      context "when the given argument is a property" do
        before do
          @community = ApartmentCommunity.new(:hyly_id => '12345')
        end

        it "returns its hyly_id" do
          Bozzuto::HyLy.pid_for(@community).should == '12345'
        end
      end

      context "when the given argument has a Hy.Ly PID" do
        it "returns the corresponding PID from the lookup table" do
          Bozzuto::HyLy.pid_for('Bozzuto Buzz').should == '1446094412836619922'
        end
      end

      context "when the given argument does not have a Hy.Ly PID" do
        it "returns nil" do
          Bozzuto::HyLy.pid_for('Test').should == nil
        end
      end
    end

    describe ".host_for" do
      context "when given a HomeCommunity" do
        it "returns the homes-specific HyLy host" do
          Bozzuto::HyLy.host_for(HomeCommunity.make).should == Bozzuto::HyLy::HOMES_HOST
        end
      end

      context "when given something other than a HomeCommunity" do
        it "returns the primary HyLy host" do
          Bozzuto::HyLy.host_for(ApartmentCommunity.make).should == Bozzuto::HyLy::PRIMARY_HOST
        end
      end
    end

    describe ".seed_pids" do
      before do
        @capitol  = ApartmentCommunity.make(:title => 'Capitol at Chelsea', :hyly_id => 'existing')
        @halstead = ApartmentCommunity.make(:title => 'Halstead Danvers',   :hyly_id => nil)
        @kent     = ApartmentCommunity.make(:title => '111 Kent',           :hyly_id => nil)

        Bozzuto::HyLy.stubs(:pid_file).returns(Rails.root.join('test', 'files', 'hyly_pids.csv'))
      end

      it "updates the properties' hyly_ids as appropriate" do
        Bozzuto::HyLy.seed_pids

        @capitol.reload.hyly_id.should  == 'existing'
        @halstead.reload.hyly_id.should == '1477193523034471277'
        @kent.reload.hyly_id.should     == '1451448400987805744'
      end
    end
  end
end
