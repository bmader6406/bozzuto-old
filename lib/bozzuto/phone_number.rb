module Bozzuto
  class PhoneNumber
    attr_reader :value

    def self.format(input)
      input.to_s.gsub(/[^\d]/, '').last(10) unless input.blank?
    end

    def initialize(input)
      @value = self.class.format(input)
    end

    def to_s
      return value.to_s if value.blank?

      match = value.match(/(\d{3})(\d{3})(\d{4})/)

      [match[1], match[2], match[3]].join('.')
    end
  end
end
