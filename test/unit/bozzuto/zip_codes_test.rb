require 'test_helper'

class ZipCodesTest < ActiveSupport::TestCase
  context "Bozzuto::ZipCodes" do
    describe ".load" do
      before do
        Bozzuto::ZipCodes::FILE = Rails.root.join('test', 'fixtures', 'zipcode_data.csv')
      end

      it "creates a ZipCode for each row in the CSV" do
        Bozzuto::ZipCodes.load

        ZipCode.count.should == 3

        zip1 = ZipCode.find_by_zip('00210')
        zip1.latitude.to_f.should  == 43.005895
        zip1.longitude.to_f.should == -71.013202

        zip2 = ZipCode.find_by_zip('56096')
        zip2.latitude.to_f.should  == 44.234274
        zip2.longitude.to_f.should == -93.5884

        zip3 = ZipCode.find_by_zip('99950')
        zip3.latitude.to_f.should  == 55.875767
        zip3.longitude.to_f.should == -131.46633
      end
    end
  end
end
