require 'test_helper'

class Bozzuto::HyLyTest < ActiveSupport::TestCase
  context ".pid_for" do
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
end
