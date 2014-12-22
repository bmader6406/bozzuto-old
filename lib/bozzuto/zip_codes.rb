module Bozzuto
  class ZipCodes
    FILE = Rails.root.join('db', 'seeds', 'zipcode_data.csv')

    def self.load
      new.load
    end

    def load
      CSV.foreach(FILE, headers: true) do |row|
        ZipCode.create(row.to_hash)
      end
    end
  end
end
