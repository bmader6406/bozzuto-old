module Bozzuto
  module ExternalFeed
    module LoadingProcess
      def self.included(base)
        base.class_eval do
          extend ClassMethods

          class_attribute :load_interval, :process_identifier

          self.load_interval = 2.hours
          self.process_identifier = 'test'
        end
      end

      def lock_file
        Rails.root.join("tmp/#{process_identifier}.lock")
      end

      def tmp_file
        Rails.root.join("tmp/#{process_identifier}")
      end

      def already_loading?
        File.exists?(lock_file)
      end

      def can_load?
        !already_loading? && Time.now >= next_load_at
      end

      def next_load_at
        if last_loaded_at
          last_loaded_at + load_interval
        else
          Time.now - 1.minute
        end
      end

      def last_loaded_at
        if File.exists?(tmp_file)
          File.new(tmp_file).mtime
        else
          nil
        end
      end

      def run_load_process(&block)
        return false unless can_load?

        begin
          touch_lock_file
          yield block
          touch_tmp_file
        ensure
          rm_lock_file
        end

        true
      end

      module ClassMethods
        def allow_loading_every(duration)
          self.load_interval = duration
        end

        def identify_loading_process_as(identifier)
          self.process_identifier = identifier
        end
      end

      private

      #:nocov:
      def touch_tmp_file
        FileUtils.touch(tmp_file)
      end

      def touch_lock_file
        FileUtils.touch(lock_file)
      end

      def rm_lock_file
        File.delete(lock_file) if File.exists?(lock_file)
      end
      #:nocov:
    end
  end
end
