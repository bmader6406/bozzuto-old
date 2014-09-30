# :nocov:
module Bozzuto
  module MissingFiles
    def self.included(base)
      base.class_eval do
        def self.missing_files
          all.select(&:missing_files?)
        end
      end
    end

    def missing_files?
      fields_with_missing_file.any?
    end

    def fields_with_missing_file
      attachments = self.class.attachment_definitions.keys

      attachments.select do |attachment|
        send(attachment).file_missing?
      end
    end
  end
end
# :nocov:
