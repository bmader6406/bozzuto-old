module Bozzuto
  module Data
    class ModelMigrator 
      ASSOCIATION_MACROS = %i(
        has_one
        has_many
      )

      LOG_COLORS = {
        info:    34,
        success: 32,
        warn:    33,
        failure: 31
      }

      attr_reader :origin_class,
                  :target_class,
                  :config,
                  :origin_scope,
                  :target_scope,
                  :records,
                  :record_count

      attr_accessor :success_count, :failure_count

      def initialize(origin_class:, target_class:, **config)
        @origin_class  = origin_class
        @target_class  = target_class
        @config        = config
        @origin_scope  = config.fetch(:origin_scope, origin_class.all)
        @target_scope  = config.fetch(:target_scope, target_class.all)
        @records       = config.fetch(:records, origin_scope)
        @record_count  = records.count
        @success_count = 0
        @failure_count = 0
      end

      def migrate
        log "Beginning migration of #{record_count} #{origin_class} records to #{target_class} records..", :success

        records.each do |origin|
          target_scope.find_or_initialize_by(id: origin.id) do |target|
            populate_fields       from: origin, to: target
            populate_associations from: origin, to: target

            target.save

            validate target, origin
          end
        end

        logger.debug(migration_summary)
      end

      private

      def populate_fields(from:, to:)
        target_attributes_for(from).each do |(field, value)|
          to.send(field.to_s + '=', value)
        end
      end

      def populate_associations(from:, to:)
        associations.each do |association|
          records = from.send(association.name)

          next if records.nil? || association.options[:through].present?

          options = { association.foreign_key => to.id }
          options.merge!(association.foreign_key.to_s.gsub('id', 'type') => target_class.name) if association.options[:as]

          records.respond_to?(:update_all) ? records.update_all(options) : records.update_attributes(options)
        end
      end

      def associations
        @associations ||= Array(config.fetch(:associations, origin_class.reflect_on_all_associations)).map do |association|
          if association.respond_to?(:macro) && ASSOCIATION_MACROS.include?(association.macro)
            association
          elsif !association.respond_to?(:macro)
            origin_class.reflect_on_all_associations.find { |a| a.name.to_s == association.to_s && ASSOCIATION_MACROS.include?(a.macro) }
          end
        end.compact
      end

      def dependencies
        @dependencies ||= Array(config.fetch(:associations, target_class.reflect_on_all_associations)).map do |association|
          if association.respond_to?(:macro) && association.macro == :belongs_to
            association
          elsif !association.respond_to?(:macro)
            target_class.reflect_on_all_associations.find { |a| a.name.to_s == association.to_s && a.macro == :belongs_to }
          end
        end.compact
      end

      def target_attributes_for(record)
        field_mappings.reduce(Hash.new) do |attributes, (field, mapper)|
          attributes.merge(field => mapper.call(record))
        end
      end

      def field_mappings
        config.fetch(:field_mappings, default_field_mappings)
      end

      def default_field_mappings
        attributes.reduce(Hash.new) do |mapping, column|
          mapping.merge(column.name => -> (record) { record.send(column.name) if record.respond_to?(column.name) })
        end
      end

      def attributes
        @attributes ||= target_class.columns.select do |column|
          dependencies.map(&:name).exclude? column.name.to_sym
        end
      end

      def logger
        @logger ||= Logger.new(Rails.env.test? ? '/dev/null' : $stdout)
      end

      def log(message, type = :info)
        logger.debug("\e[#{LOG_COLORS.fetch(type)}m#{message}\e[0m")
      end

      def validate(target, origin)
        success = true

        log "Validating migration of #{origin} (#{origin_class}) to #{target} (#{target_class}).."

        if target.persisted?
          field_mappings.each do |(field, mapper)|
            original_value = mapper.call(origin)
            mapped_value   = target.read_attribute(field)

            if mapped_value != original_value && unvalidated_fields.exclude?(field.to_s)
              log "#{field.titleize} does not match!  Original Value: '#{original_value}' // Mapped Value: '#{mapped_value}'", :warn

              success = false
            end
          end
        else
          log target.errors.full_messages.join('; '), :failure
          success = false
        end

        if success
          self.success_count += 1
          log "Successfully migrated #{origin} (#{origin_class}) to #{target} (#{target_class})!", :success
        else
          self.failure_count += 1
          log "Failed to successfully migrate #{origin} (#{origin_class}) to #{target} (#{target_class})!", :failure
        end
      end

      def unvalidated_fields
        @unvalidated_fields ||= Array(config.fetch(:skip_validations_for, [])).map(&:to_s)
      end

      def migration_summary
        "*** MIGRATION RESULTS:  \e[#{LOG_COLORS[:success]}m#{success_count} successful\e[0m, \e[#{LOG_COLORS[:failure]}m#{failure_count} failed\e[0m. ***"
      end
    end
  end
end
