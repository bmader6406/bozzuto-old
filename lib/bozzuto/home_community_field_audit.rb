module Bozzuto
  class HomeCommunityFieldAudit < CommunityFieldAudit
    AUDIT_FIELDS = ActiveSupport::OrderedHash[[
      ['Street Address',             :street_address],
      ['County',                     lambda {|c| c.county.try(:name) }],
      ['Zip Code',                   :zip_code],
      ['Phone Number',               :phone_number],
      ['Mobile Phone Number',        :mobile_phone_number],
      ['MediaMind Activity ID for "Contact" Page', :contact_mediamind_id],
      ['MediaMind Activity ID for "Send to Friend" Thank You Page', :send_to_friend_mediamind_id],
      ['MediaMind Activity ID for "Send to Phone" Thank You Page', :send_to_phone_mediamind_id],
      ['Website URL',                :website_url],
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
      ['DNR configuration',          :dnr_configuration],
      ['Conversion Configuration',   :conversion_configuration],
      ['Property Features Page',     :features_page],
      ['Property Neighborhood Page', lambda {|c| c.neighborhood_page.try(:content)}],
      ['Property Contact Page',      lambda {|c| c.contact_page.try(:content)}],
      ['Lasso Account',              :lasso_account],
      ['Floor Plans'  ,              lambda {|c| c.featured_homes.any?(&:floor_plans)}],
      ['Photos',                     :photos]
    ]]

    def self.community_records
      HomeCommunity.all
    end
    
    def self.audit_fields
      AUDIT_FIELDS
    end
  end
end
