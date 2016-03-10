module Bozzuto
  module Model
    module Community
      extend ActiveSupport::Concern

      PAGES = %i(
        features_page
        neighborhood_page
        contact_page
        tours_page
      )

      included do
        include Bozzuto::SMSAble

        acts_as_list column: 'featured_position'

        belongs_to :local_info_feed, class_name: 'Feed'
        belongs_to :promo
        belongs_to :twitter_account
        belongs_to :county

        has_one :dnr_configuration, as: :property, dependent: :destroy

        has_many :landing_page_popular_orderings,                   as: :property, dependent: :destroy
        has_many :photos,                                           as: :property
        has_many :videos,             -> { order(position: :asc) }, as: :property
        has_many :office_hours,       -> { order(:day) },           as: :property, dependent: :destroy
        has_many :property_amenities, -> { order(:position) },      as: :property, dependent: :destroy

        has_attached_file :hero_image,
          url:             '/system/:class/:id/:attachment_name/:style.:extension',
          styles:          { resized: '1020x325#' },
          default_style:   :resized,
          convert_options: { all: '-quality 80 -strip' }

        validates_attachment_content_type :hero_image, content_type: /\Aimage\/.*\Z/

        accepts_nested_attributes_for :office_hours, :property_amenities, allow_destroy: true

        Bozzuto::Model::Community::PAGES.each do |page_type|
          klass_name = "Property#{page_type.to_s.classify}"

          has_one page_type, class_name: klass_name, foreign_key: :property_id

          define_method "#{page_type}?" do
            self.send(page_type).present?
          end
        end

        accepts_nested_attributes_for :dnr_configuration

        before_save :set_featured_postion
        before_save :format_phone_number,        if: :phone_number?
        before_save :format_mobile_phone_number, if: :mobile_phone_number?

        scope :featured_order,       -> { order('featured DESC, featured_position ASC, title ASC') }
        scope :with_twitter_account, -> { where('twitter_account_id > 0') }

        scope :sort_for, -> (landing_page) {
          #:nocov:
          if landing_page.respond_to?(:randomize_property_listings?)
            order(landing_page.randomize_property_listings? ? 'RAND(NOW())' : 'apartment_communities.title ASC')
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

        def local_info
          has_local_info? ? local_info_feed.items : []
        end

        def has_local_info?
          local_info_feed.present? && local_info_feed.items.any?
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

        # used by sms
        def phone_message
          "#{title} #{street_address}, #{city.name}, #{city.state.name} #{phone_number} Call for specials! #{website_url}"
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
