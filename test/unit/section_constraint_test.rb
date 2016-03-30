require 'test_helper'

class SectionConstraintTest < ActiveSupport::TestCase
  context "A SectionConstraint" do
    before do
      @request = mock('ActionDispatch::Request')
    end

    describe "#matches?" do
      {
        "http://host.com/careers"              => true,
        "http://host.com/sections/careers"     => true,
        "http://host.com/sections/system"      => true,
        "http://host.com/system/thumb/img.jpg" => false
      }.each do |url, bool|
        it "returns #{bool} for #{url}" do
          @request.stubs(:url).returns(url)

          SectionConstraint.new.matches?(@request).should == bool
        end
      end
    end
  end
end
