require 'test_helper'

class ZipCodesTest < ActiveSupport::TestCase
  context "Bozzuto::ZipCodes" do
    describe ".load" do
      before do
        Bozzuto::ZipCodes::FILE = Rails.root.join('test', 'fixtures', 'zipcode_data.csv')
      end

      it "creates a ZipCode for each row in the CSV" do
        expect { Bozzuto::ZipCodes.load }.to change { ZipCode.count }.by 3

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

      context "when there are existing ZIP codes" do
        before do
          @zip_code = ZipCode.create(zip: '00210', latitude: 43.005895, longitude: -71.013202)
        end

        it "does not duplicate ZIP codes" do
          Bozzuto::ZipCodes.load

          ZipCode.where(zip: '00210').count.should == 1
        end
      end
    end
  end
end
