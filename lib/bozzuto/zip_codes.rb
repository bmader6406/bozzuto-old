module Bozzuto
  class ZipCodes
    class_attribute :file, :instance_accessor => false
    self.file = Rails.root.join('db', 'seeds', 'zipcode_data.csv')

    def self.load
      new.load
    end

    def load
      CSV.foreach(self.class.file, headers: true) do |row|
        ZipCode.find_or_create_by_zip_and_latitude_and_longitude(*row.fields)
      end
    end
  end
end
