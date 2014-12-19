require 'test_helper'

class ZipCodeTest < ActiveSupport::TestCase
  context "ZipCode" do
    @zip = ZipCode.create(zip: '12345', latitude: 50.10, longitude: -90.50)

    should validate_presence_of(:zip)
    should validate_presence_of(:latitude)
    should validate_presence_of(:longitude)
    should validate_uniqueness_of(:zip)
  end
end
