module Bozzuto
  class ZipCodes
    FILE = Rails.root.join('db', 'seeds', 'zipcode_data.csv')

    def self.load
      new.load
    end

    def load
      CSV.foreach(FILE, headers: true) do |row|
        ZipCode.find_or_create_by_zip_and_latitude_and_longitude(*row.fields)
      end
    end
  end
end
