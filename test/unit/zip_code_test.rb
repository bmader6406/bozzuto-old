require 'test_helper'

class ZipCodeTest < ActiveSupport::TestCase
  context "ZipCode" do
    before do
      @zip = ZipCode.create(zip: '12345', latitude: 50.12.to_d, longitude: -82.57.to_d)
    end

    should validate_presence_of(:zip)
    should validate_presence_of(:latitude)
    should validate_presence_of(:longitude)
    should validate_uniqueness_of(:zip)
  end
end
