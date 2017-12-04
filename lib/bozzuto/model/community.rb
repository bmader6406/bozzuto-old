module Bozzuto
  module Model
    module Community
      extend ActiveSupport::Concern

      PAGES = %i(
        features_page
        neighborhood_page
        contact_page
        tours_page
        retail_page
      )

      included do
        extend Bozzuto::Neighborhoods::ListingImage

        belongs_to :promo
        belongs_to :twitter_account

        has_one :dnr_configuration, as: :property, dependent: :destroy

        has_many :landing_page_popular_orderings,                   as: :property, dependent: :destroy, inverse_of: :property
        has_many :photos,                                           as: :property,                      inverse_of: :property
        has_many :videos,             -> { order(position: :asc) }, as: :property,                      inverse_of: :property
        has_many :office_hours,       -> { order(:day) },           as: :property, dependent: :destroy, inverse_of: :property
        has_many :property_amenities, -> { order(:position) },      as: :property, dependent: :destroy, inverse_of: :property

        has_neighborhood_listing_image :neighborhood_listing_image, required: false

        accepts_nested_attributes_for :office_hours, :property_amenities, allow_destroy: true

        Bozzuto::Model::Community::PAGES.each do |page_type|
          klass_name = "Property#{page_type.to_s.classify}"

          # has_one page_type, class_name: klass_name, foreign_key: :property_id

          # removed  has_one relation since it doesn't takes property_type
          define_method "#{page_type}" do
            "Property#{page_type.to_s.classify}".constantize.
              find_by_property_id_and_property_type(self.id, self.class.name)
          end

          define_method "#{page_type}?" do
            self.send(page_type).present?
          end
        end

        accepts_nested_attributes_for :dnr_configuration

        before_save :format_phone_number,        if: :phone_number?
        before_save :format_mobile_phone_number, if: :mobile_phone_number?

        scope :with_twitter_account, -> { where('twitter_account_id > 0') }

        scope :sort_for, -> (landing_page) {
          #:nocov:
          if landing_page.respond_to?(:randomize_property_listings?)
            order(landing_page.randomize_property_listings? ? 'RAND(NOW())' : "#{table_name}.title ASC")
          else
            all
          end
          #:nocov:
        }

        delegate :latest_tweet, to: :twitter_account, allow_nil: true

        def pages
          @pages ||= PAGES.map { |page| public_send(page) }.compact
        end

        def overview_bullets
          [overview_bullet_1, overview_bullet_2, overview_bullet_3].reject(&:blank?)
        end

        def has_overview_bullets?
          overview_bullets.any?
        end

        def has_active_promo?
          promo.present? && promo.active?
        end

        def has_media?
          photos.any? || videos.any?
        end

        def grouped_photos
          photos.positioned.grouped
        end

        def mobile_phone_number
          super.presence || phone_number
        end

        def twitter_handle
          twitter_account.try(:username)
        end

        def phone_number
          Bozzuto::PhoneNumber.new(read_attribute(:phone_number)).to_s
        end

        def mobile_phone_number
          Bozzuto::PhoneNumber.new(read_attribute(:mobile_phone_number)).to_s.presence || phone_number
        end

        private

        def format_phone_number
          self.phone_number = Bozzuto::PhoneNumber.format(phone_number)
        end

        def format_mobile_phone_number
          self.mobile_phone_number = Bozzuto::PhoneNumber.format(mobile_phone_number)
        end
      end
    end
  end
end
