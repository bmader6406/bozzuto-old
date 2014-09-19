module Bozzuto
  class CommunityFieldAudit

    IDENTIFIER_FIELDS = ActiveSupport::OrderedHash[[
      ["ID",    :id],
      ["Title", :title]
    ]]

    def self.audit_csv
      CSV.generate do |csv|
        csv << identifier_fields.keys.concat(audit_fields.keys)
        community_records.each do |community|
          csv << new(community).to_a
        end
      end
    end

    #:nocov:
    def self.community_records
      raise ".community_records must be defined in subclass"
    end

    def self.audit_fields
      raise ".audit_fields must be defined in subclass"
    end
    #:nocov:

    def self.identifier_fields
      IDENTIFIER_FIELDS
    end

    attr_reader :community

    def initialize(community)
      @community = community
    end

    def to_a
      identifier_columns.concat(field_presence_audit)
    end

    def identifier_columns
      self.class.identifier_fields.values.map do |field|
        field_value(field)
      end
    end

    def field_presence_audit
      self.class.audit_fields.values.map do |field|
        field_presence(field)
      end
    end

    def field_value(field)
      if field.is_a?(Symbol)
        community.send(field)
      else
        field.call(community) rescue nil
      end
    end

    def field_presence(field)
      field_value(field).present? ? "Filled" : "Empty"
    end
  end
end
