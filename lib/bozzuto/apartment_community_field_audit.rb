module Bozzuto
  class ApartmentCommunityFieldAudit
    AUDIT_FIELDS = ActiveSupport::OrderedHash[[
      ['Street Address',             :street_address],
      ['County',                     lambda {|c| c.county.try(:name) }],
      ['Zip Code',                   :zip_code],
      ['Phone Number',               :phone_number],
      ['Mobile Phone Number',        :mobile_phone_number],
      ['Website URL',                :website_url],
      ['Availability URL',           :availability_url],
      ['Facebook URL',               :facebook_url],
      ['Twitter Account',            lambda {|c| c.twitter_account.try(:username) }],
      ['Listing Title',              :listing_title],
      ['Listing Copy',               :listing_text],
      ['Overview SEO Title',         :meta_title],
      ['Overview SEO Description',   :meta_description],
      ['Overview SEO Keywords',      :meta_keywords],
      ['Overview Title',             :overview_title],
      ['Overview Copy',              :overview_text],
      ['Overview Bullet #1',         :overview_bullet_1],
      ['Overview Bullet #2',         :overview_bullet_2],
      ['Overview Bullet #3',         :overview_bullet_3],
      ['Lead2Lease Email',           :lead_2_lease_email],
      ['DNR configuration',          :dnr_configuration],
      ['Mediaplex Tag',              :mediaplex_tag],
      ['Property Features Page',     :features_page],
      ['Property Neighborhood Page', lambda {|c| c.neighborhood_page.try(:content)}],
      ['Property Contact Page',      lambda {|c| c.contact_page.try(:content)}],
      ['Floor Plans',                :floor_plans],
      ['Flickr Photo Set',           :photo_set]
    ]]

    IDENTIFIER_FIELDS = ActiveSupport::OrderedHash[[
      ["ID",    :id],
      ["Title", :title]
    ]]

    def self.audit_csv
      FasterCSV.generate do |csv|
        csv << identifier_fields.keys.concat(audit_fields.keys)
        ApartmentCommunity.all.each do |apt_community|
          csv << new(apt_community).to_a
        end
      end
    end

    def self.audit_fields
      AUDIT_FIELDS
    end

    def self.identifier_fields
      IDENTIFIER_FIELDS
    end

    attr_reader :apartment_community

    def initialize(apartment_community)
      @apartment_community = apartment_community
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
        apartment_community.send(field)
      else
        field.call(apartment_community) rescue nil
      end
    end

    def field_presence(field)
      field_value(field).present? ? "Filled" : "Empty"
    end
  end
end
