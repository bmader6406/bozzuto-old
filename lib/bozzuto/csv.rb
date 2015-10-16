require 'csv'

module Bozzuto
  class Csv
    class_attribute :klass, :field_map

    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def record_lookup_options
      { :conditions => conditions, :batch_size => batch_size }
    end

    def conditions
      options[:conditions]
    end

    def batch_size
      options.fetch(:batch_size, 1000)
    end

    def filename
      options.fetch(:filename, default_filename)
    end

    def default_filename
      "#{Rails.root}/tmp/export-#{klass.table_name}-#{timestamp}.csv"
    end

    def timestamp
      Time.now.utc.to_s(:number)
    end

    def field_names
      field_map.keys
    end

    def attr_readers
      field_map.values
    end

    def string
      @string ||= CSV.generate(&content)
    end

    def file
      @file ||= File.open(filename, 'w') do |file|
        file.write(string)
        file.path
      end
    end

    private

    def content
      lambda do |csv|
        csv << field_names

        klass.find_in_batches(record_lookup_options) do |records|
          records.each do |record|
            csv << attr_readers.map do |reader|
              value = if reader.respond_to?(:call)
                reader.call(record)
              elsif !reader.nil?
                record.send(reader)
              else
                ''
              end

              value.presence || ''
            end
          end
        end
      end
    end
  end
end
