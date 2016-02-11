module Bozzuto
  class ZipCodes

    class_attribute :file, :instance_accessor => false

    self.file = Rails.root.join('db', 'seeds', 'zipcode_data.csv')

    def self.load
      new.load
    end

    def load
      CSV.foreach(self.class.file, headers: true) do |row|
        ZipCode.find_or_create_by(
          zip:       row['zip'],
          latitude:  row['latitude'],
          longitude: row['longitude']
        )
      end
    end
  end
end
