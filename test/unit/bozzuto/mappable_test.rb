require 'test_helper'

class MappableTest < ActiveSupport::TestCase
  context "The Mappable module" do
    describe "#as_jmapping" do
      subject { Metro.make }

      it "returns the hash" do
        hash = subject.as_jmapping

        hash[:id].should == subject.id
        hash[:category].should == 'Metro'
        hash[:point].should == {
          :lat => subject.latitude,
          :lng => subject.longitude
        }
      end
    end
  end
end
