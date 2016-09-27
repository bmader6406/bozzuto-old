module Bozzuto
  module Model
    module Property
      extend ActiveSupport::Concern

      included do
        extend FriendlyId

        include Bozzuto::Mappable
        include Bozzuto::Publishable

        friendly_id :id_and_title, use: :history

        belongs_to :city
        belongs_to :county

        has_one :slideshow, as: :property, class_name: 'PropertySlideshow'

        has_many :property_feature_attributions,
          -> { joins(:property_feature).order('property_features.position ASC') },
          as:         :property,
          dependent:  :destroy,
          inverse_of: :property

        has_many :property_features, through: :property_feature_attributions

        has_attached_file :listing_image,
          url:             '/system/:class/:id/:style.:extension',
          styles:          { square: '150x150#', rect: '230x145#' },
          default_style:   :square,
          convert_options: { all: '-quality 80 -strip' }

        has_attached_file :brochure, url: '/system/:class/:id/brochure.:extension'

        validates_attachment_content_type :listing_image, content_type: /\Aimage\/.*\Z/

        do_not_validate_attachment_file_type :brochure

        validates :title,
                  :city,
                  presence: true

        validates :short_title,
                  allow_nil:    true,
                  length:       { maximum: 22 }

        validate :brochure_url_xor_file

        after_create :create_correct_slug

        scope :mappable,         -> { where('latitude IS NOT NULL AND longitude IS NOT NULL') }
        scope :ordered_by_title, -> { order(title: :asc) }
        scope :position_asc,     -> { order(position: :asc) }
        scope :in_state,         -> (state_id) { joins(:city).where(cities: { state_id: state_id }) }
        scope :duplicates,       -> {
          joins("INNER JOIN #{table_name} AS other ON #{table_name}.title SOUNDS LIKE other.title")
            .where("#{table_name}.id != other.id")
            .order('title ASC')
        }

        def self.ransackable_scopes(auth_object = nil)
          [:in_state]
        end

        def self.near(origin)
          scoped = by_distance(:origin => origin)

          if origin.is_a?(Property)
            scoped = scoped.where(['id != ?', origin.id])
          end

          scoped
        end

        def to_s
          title
        end

        def to_label
          to_s
        end

        def short_name
          short_title.presence || title
        end

        def address(separator = ', ')
          [street_address, city].reject(&:blank?).join(separator)
        end

        def as_jmapping
          super.merge(:name => Rack::Utils.escape_html(title))
        end

        def state
          city.state
        end

        def mappable?
          latitude.present? && longitude.present?
        end

        def uses_brochure_url?
          brochure_url.present?
        end

        def uses_brochure_file?
          brochure.present?
        end

        def destroy_attached_files
          # no-op this because we need to keep attachments arround
        end

        def apartment?
          is_a? ::ApartmentCommunity
        end
        alias_method :apartment_community?, :apartment?

        def home?
          is_a? ::HomeCommunity
        end
        alias_method :home_community?, :home?

        def project?
          is_a? ::Project
        end

        def seo_link?
          seo_link_text.present? && seo_link_url.present?
        end

        def id_and_title
          [id, title].join('-').parameterize
        end

        def id_and_title_changed?
          id_changed? || title_changed?
        end

        private

        def create_correct_slug
          update_attributes(slug: id_and_title)
        end

        def brochure_url_xor_file
          if brochure_link_text.present? && !(brochure.present? ^ brochure_url.present?)
            errors.add :brochure_link_text, "either brochure file or brochure url must be present if link text present, but not both"
          end
        end
      end
    end
  end
end
