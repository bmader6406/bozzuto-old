class ApartmentCommunity < ActiveRecord::Base
  include Bozzuto::Model::Property
  include Bozzuto::Model::Community
  include Bozzuto::ExternalFeed::Model
  include Bozzuto::ApartmentFloorPlans::HasCache
  include Bozzuto::AlgoliaSiteSearch

  self.external_cms_attributes = [
    :title,
    :street_address,
    :city,
    :county,
    :availability_url,
    :floor_plans
  ]

  def self.ransackable_scopes(auth_object = nil)
    [
      :in_state,
      :with_min_price,
      :with_max_price,
      :with_any_floor_plan_groups,
      :with_any_property_features,
      :with_exact_floor_plan_groups,
      :with_exact_property_features,
      :having_all_floor_plan_groups,
      :having_all_property_features
    ]
  end

  acts_as_list column: :featured_position

  after_save    :update_caches
  after_destroy :update_caches

  has_many :floor_plans, class_name: 'ApartmentFloorPlan', dependent: :destroy
  has_many :floor_plan_groups, -> { uniq },
           class_name: 'ApartmentFloorPlanGroup',
           through:    :floor_plans

  has_many :featured_floor_plans, -> { where(featured: true).order(bedrooms: :asc, position: :asc) }, class_name: 'ApartmentFloorPlan'

  has_many :under_construction_leads, -> { order(created_at: :desc) }

  has_one :mediaplex_tag, as: :trackable

  has_one :contact_configuration, class_name: 'ApartmentContactConfiguration'

  has_one :neighborhood, foreign_key: :featured_apartment_community_id, dependent: :nullify

  has_many :neighborhood_memberships, inverse_of: :apartment_community, dependent: :destroy
  has_many :area_memberships,         inverse_of: :apartment_community, dependent: :destroy

  has_attached_file :hero_image,
    url:             '/system/:class/:id/:attachment_name/:style.:extension',
    styles:          { resized: '1020x325#' },
    default_style:   :resized,
    convert_options: { all: '-quality 80 -strip' }


  algolia_site_search if: :published do
    attribute :title, :zip_code, :listing_text, :neighborhood_description, :overview_text
    has_one_attribute :city, :name
    has_many_attribute :property_features, :name
    has_many_attribute :property_amenities, :primary_type
  end


  validates_attachment_content_type :hero_image, content_type: /\Aimage\/.*\Z/

  validates_presence_of :lead_2_lease_email, if: :show_lead_2_lease?

  validates_inclusion_of :included_in_export, in: [true, false]

  validates_length_of :short_description, maximum: 40, allow_nil: true

  serialize :office_hours

  before_save :set_featured_postion

  accepts_nested_attributes_for :mediaplex_tag, :contact_configuration

  scope :included_in_export,   -> { where(included_in_export: true) }
  scope :found_in_latest_feed, -> { where(found_in_latest_feed: true) }
  scope :featured_order,       -> { order('featured DESC, featured_position ASC, title ASC') }

  scope :with_min_price, -> (price) {
    joins("JOIN apartment_floor_plan_caches AS cache ON cache.cacheable_id = apartment_communities.id AND cache.cacheable_type = 'ApartmentCommunity'")
      .where('cache.max_price >= ?', price.to_i)
  }

  scope :with_max_price, -> (price) {
    joins("JOIN apartment_floor_plan_caches AS cache ON cache.cacheable_id = apartment_communities.id AND cache.cacheable_type = 'ApartmentCommunity'")
      .where('cache.min_price <= ?', price.to_i)
  }

  scope :with_any_floor_plan_groups,   -> (ids) { where(Bozzuto::Searches::Partial::FloorPlanSearch.new(ids).sql) }
  scope :with_any_property_features,   -> (ids) { where(Bozzuto::Searches::Partial::FeatureSearch.new(ids).sql) }
  scope :with_exact_floor_plan_groups, -> (ids) { where(Bozzuto::Searches::Exact::FloorPlanSearch.new(ids).sql) }
  scope :with_exact_property_features, -> (ids) { where(Bozzuto::Searches::Exact::FeatureSearch.new(ids).sql) }
  scope :having_all_floor_plan_groups, -> (ids) { where(Bozzuto::Searches::Full::FloorPlanSearch.new(ids).sql) }
  scope :having_all_property_features, -> (ids) { where(Bozzuto::Searches::Full::FeatureSearch.new(ids).sql) }

  scope :featured, -> { joins(:apartment_floor_plans).where(apartment_floor_plans: { featured: true }) }

  scope :under_construction,     -> { where(under_construction: true) }
  scope :not_under_construction, -> { where(under_construction: false) }

  def external_cms_attributes
    self.class.external_cms_attributes
  end

  def nearby_communities(limit = 6)
    @nearby_communities ||= city.apartment_communities.published.near(self).limit(limit)
  end

  def merge(other_community)
    raise 'Receiver must not be an externally-managed community' if managed_externally?
    raise 'Argument must be an externally-managed community' unless other_community.managed_externally?

    self.external_cms_id   = other_community.external_cms_id
    self.external_cms_type = other_community.external_cms_type

    other_community.slugs.update_all(sluggable_id: id)
    other_community.update_attributes(external_cms_id: nil, external_cms_type: nil)

    external_cms_attributes.each { |attr| self.send("#{attr}=", other_community.send(attr)) }

    save

    # reload floor plans to clear other_community's cache so it doesn't delete them
    other_community.floor_plans(true)
    other_community.destroy
  end

  def jmapping_category
    under_construction? ? 'UpcomingApartment' : super
  end

  def disconnect_from_external_cms!
    self.external_cms_id   = nil
    self.external_cms_type = nil

    floor_plans.each do |plan|
      plan.disconnect_from_external_cms!
    end

    save
  end

  def available_floor_plans(reload = true)
    @available_floor_plans = nil if reload

    @available_floor_plans ||= if managed_externally?
      floor_plans.externally_available.available
    else
      floor_plans.available
    end
  end

  def floor_plans_for_caching
    available_floor_plans
  end

  def update_caches
    invalidate_apartment_floor_plan_cache!

    true
  end

  def invalidate_apartment_floor_plan_cache!
    super

    neighborhood_memberships(true).each(&:invalidate_apartment_floor_plan_cache!)
    area_memberships(true).each(&:invalidate_apartment_floor_plan_cache!)

    true
  end

  def id_for_export
    core_id.presence || id
  end

  def main_export_community?
    included_in_export? && published?
  end

  def to_s
    title
  end

  def description
    listing_text
  end

  protected

  def scope_condition
    "#{self.class.table_name}.city_id IN (SELECT id FROM cities WHERE cities.state_id = #{city.state_id}) AND #{self.class.table_name}.featured = 1"
  end

  def add_to_list_bottom
    # no-op. this is called after the before_save #set_featured_position callback
    # on create, which causes a featured_position of 1 to be set by default.
    # override here to prevent that from happening
  end

  def set_featured_postion
    if featured_changed? || new_record?
      if featured?
        except = new_record? ? nil : self
        self.featured_position = bottom_position_in_list(except).to_i + 1
      else
        self.featured_position = nil
      end
    end
  end
end
