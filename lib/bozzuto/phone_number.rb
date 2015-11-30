module Bozzuto
  class PhoneNumber
    def self.format(input)
      input.gsub(/[^\d]/, '').last(10)
    end
  end
end
