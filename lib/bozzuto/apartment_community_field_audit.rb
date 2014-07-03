module Bozzuto
  class ApartmentCommunityFieldAudit < CommunityFieldAudit
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
      ['Photos',                     :photos]
    ]]

    def self.community_records
      ApartmentCommunity.all
    end
    
    def self.audit_fields
      AUDIT_FIELDS
    end
  end
end
