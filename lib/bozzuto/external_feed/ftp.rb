require 'net/ftp'

module Bozzuto
  module ExternalFeed
    module Ftp

      def self.types
        Bozzuto::ExternalFeed.constants.map { |constant|
          Bozzuto::ExternalFeed.const_get(constant)
        }.select do |klass|
          Class === klass && klass.included_modules.include?(self)
        end
      end

      def self.download_files
        Bozzuto::ExternalFeed::LiveBozzutoFtp.download_files
      end

      def self.included(base)
        base.class_eval do
          class_attribute :username, :password, :ftp_name

          def self.download_files
            new.download_files
          end

          def self.transfer(file, opts = {})
            new.transfer(file, opts)
          end
        end
      end

      def transfer(file, options = {})
        raise ArgumentError, 'The given file name does not exist.' unless ::File.exists?(file)

        return if Rails.env.development?

        dir = options[:dir]

        connect_to_server do |ftp|
          ftp.chdir(dir) if dir.present?

          ftp.putbinaryfile(file)
        end
      end

      def download_files
        run_load_process do
          connect_to_server do |ftp|
            feed_types.each do |type|
              ftp.getbinaryfile(source_file_for(type), target_location_for(type))
            end
          end
        end
      end

      private

      def connect_to_server
        Net::FTP.open server do |ftp|
          ftp.passive = true
          ftp.login(username, password)

          yield ftp
        end
      end

      def source_file_for(feed_type)
        feed_type.gsub('_', '') + '.xml'
      end

      def target_location_for(feed_type)
        key = "#{feed_type}_feed_file".to_sym
        APP_CONFIG[key]
      end

      def server
        raise NotImplementedError
      end

      def feed_types
        raise NotImplementedError
      end
    end
  end
end
