require 'test_helper'

class MappableTest < ActiveSupport::TestCase
  context "The Mappable module" do
    describe "#as_jmapping" do
      subject { Metro.make }

      it "returns the hash" do
        subject.as_jmapping.should == {
          :id => subject.id,
          :category => 'Metro',
          :point => {
            :lat => subject.latitude,
            :lng => subject.longitude
          }
        }
      end
    end
  end
end
