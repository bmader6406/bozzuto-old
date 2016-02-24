ActiveAdmin.register ApartmentCommunity do
  config.sort_order = 'title_asc'

  menu parent: 'Properties'

  permit_params :title,
                :short_title,
                :street_address,
                :city_id,
                :county_id,
                :zip_code,
                :phone_number,
                :mobile_phone_number,
                :latitude,
                :longitude,
                :ufollowup_id,
                :website_url,
                :website_url_text,
                :availability_url,
                :resident_link_text,
                :resident_link_url,
                :video_url,
                :facebook_url,
                :twitter_account,
                :brochure_link_text,
                :brochure_type,
                :brochure,
                :brochure_url,
                :schedule_tour_url,
                :local_info_feed_id,
                :listing_image,
                :listing_title,
                :listing_text,
                :neighborhood_listing_image,
                :neighborhood_description,
                :hero_image,
                :meta_title,
                :meta_description,
                :meta_keywords,
                :overview_title,
                :overview_text,
                :overview_bullet_1,
                :overview_bullet_2,
                :overview_bullet_3,
                :promo_id,
                :media_meta_title,
                :media_meta_description,
                :media_meta_keywords,
                :floor_plans_meta_title,
                :floor_plans_meta_description,
                :floor_plans_meta_keywords,
                :seo_link_text,
                :seo_link_url,
                :show_rtrk_code,
                :published,
                :featured,
                :included_in_export,
                :core_id,
                :under_construction,
                :show_lead_2_lease,
                :lead_2_lease_email,
                :lead_2_lease_id,
                :hyly_id,
                property_features_ids: [],
                contact_configuration_attributes: [
                  :id,
                  :apartment_community_id,
                  :upcoming_intro_text,
                  :upcoming_thank_you_text
                ],
                property_amenities_attributes: [
                  :id,
                  :property_id,
                  :primary_type,
                  :sub_type,
                  :description,
                  :_destroy
                ],
                dnr_configuration_attributes: [
                  :id,
                  :property_id,
                  :customer_code
                ],
                mediaplex_tag_attributes: [
                  :id,
                  :trackable_id,
                  :trackable_type,
                  :page_name,
                  :roi_name
                ],
                office_hours_attributes: [
                  :id,
                  :property_id,
                  :day,
                  :closed,
                  :opens_at,
                  :opens_at_period,
                  :closes_at,
                  :closes_at_period,
                  :_destroy
                ]

  filter :title_cont,          label: 'Title'
  filter :street_address_cont, label: 'Street Address'
  filter :city,                collection: City.includes(:state)
  filter :published
  filter :featured
  filter :included_in_export
  filter :external_cms_type,
    label:      'Managed By',
    as:         :select,
    collection: Bozzuto::ExternalFeed::Feed.feed_types.map { |feed| [I18n.t("bozzuto.feeds.#{feed}"), feed] }

  index do
    column :title
    column :published
    column :featured
    column :included_in_export
    column :external_cms_name

    actions
  end

  show do |community|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for community do
            row :title
            row :short_title
            row :street_address
            row :city
            row :county
            row :zip_code
            row :phone_number
            row :mobile_phone_number
            row :latitude
            row :longitude
            row :website_url
            row :website_url_text
            row :availability_url
            row :resident_link_text
            row :resident_link_url
            row :video_url
            row :facebook_url
            row :twitter_account
            row :brochure_link_text
            row(:brochure_type) { |community| community.brochure_type == Property::USE_BROCHURE_URL ? 'URL' : 'File' }
            row :brochure
            row :brochure_url
            row :schedule_tour_url
            row :local_info_feed
            row :listing_image do |community|
              if community.listing_image.present?
                image_tag community.listing_image
              end
            end
            row :listing_title
            row :listing_text
            row :neighborhood_listing_image do |community|
              if community.neighborhood_listing_image.present?
                image_tag community.neighborhood_listing_image
              end
            end
            row :neighborhood_description
            row :hero_image do |community|
              if community.hero_image.present?
                image_tag community.hero_image
              end
            end
            row :overview_title
            row :overview_text
            row :overview_bullet_1
            row :overview_bullet_2
            row :overview_bullet_3
            row :promo
            row :core_id
            row(:included_in_export) { |community| community.included_in_export ? status_tag(:yes) : status_tag(:no) }
            row(:published) { |community| community.published ? status_tag(:yes) : status_tag(:no) }
            row(:featured) { |community| community.featured ? status_tag(:yes) : status_tag(:no) }
          end
        end
      end

      tab 'Floor Plans' do
        collection_panel_for :floor_plans do
          reorderable_table_for community.floor_plans do
            column :name
            column :bedrooms
            column :bathrooms
            column :square_footage
            column :availability
            column :featured
          end
        end
      end

      tab 'Features' do
        collection_panel_for :property_features do
          table_for community.property_features do
            column :name
          end
        end
      end

      tab 'Amenities' do
        collection_panel_for :property_amenities do
          table_for community.property_amenities do
            column :primary_type
            column :sub_type
            column :description
          end
        end
      end

      tab 'Pages' do
        panel nil do
          table_for pages do
            column nil do |page|
              link_to page.class.name.to_s.gsub('Property', '').titleize, polymorphic_url([:new_admin, page])
            end
          end
        end
      end

      tab 'Media' do
        panel 'Slideshow' do
          collection_panel_for :slideshow do
            table_for community.slideshow do
              column :name
            end
          end
        end

        panel 'Videos' do
          collection_panel_for :videos do
            reorderable_table_for community.videos do
              column 'URL' do |video|
                link_to video.url, video.url, target: :blank
              end
            end
          end
        end

        panel 'Photos' do
          collection_panel_for :photos do
            reorderable_table_for community.photos do
              column nil do |photo|
                image_tag photo.image.url(:thumb)
              end
              column :title
              column :photo_group
            end
          end
        end
      end

      tab 'Office Hours' do
        collection_panel_for :office_hours do
          table_for community.office_hours do
            column(:day) { |office_hours| office_hours.day_name }
            column :closed
            column('Opens At') { |office_hours| office_hours.opens_at_with_period }
            column('Closes At') { |office_hours| office_hours.closes_at_with_period }
          end
        end
      end

      tab 'Contact-Related' do
        panel nil do
          attributes_table_for community do
            row :hyly_id
            row(:show_lead_2_lease) { |community| community.show_lead_2_lease ? status_tag(:yes) : status_tag(:no) }
            row :lead_2_lease_email
            row :lead_2_lease_id
            row(:under_construction) { |community| community.under_construction ? status_tag(:yes) : status_tag(:no) }
            row(:upcoming_intro_text) { |community| community.contact_configuration.try(:upcoming_intro_text) }
            row(:upcoming_thank_you_text) { |community| community.contact_configuration.try(:upcoming_thank_you_text) }
          end
        end
      end

      tab 'SEO' do
        panel nil do
          attributes_table_for community do
            row :meta_title
            row :meta_description
            row :meta_keywords
            row :media_meta_title
            row :media_meta_description
            row :media_meta_keywords
            row :floor_plans_meta_title
            row :floor_plans_meta_description
            row :floor_plans_meta_keywords
            row :seo_link_text
            row :seo_link_url
          end
        end
      end

      tab 'Codes' do
        panel nil do
          attributes_table_for community do
            row 'DNR Customer Code' do |community|
              community.dnr_configuration.try(:customer_code)
            end
            row 'Mediaplex Page Name' do |community|
              community.mediaplex_tag.try(:page_name)
            end
            row 'Mediaplex ROI Name' do |community|
              community.mediaplex_tag.try(:roi_name)
            end
            row :ufollowup_id
            row :show_rtrk_code do |community|
              community.show_rtrk_code ? status_tag(:yes) : status_tag(:no)
            end
          end
        end
      end
    end
  end

  form do |f|
    inputs do
      tabs do
        tab 'Details' do
          input :title
          input :short_title
          input :street_address
          input :city, collection: cities
          input :county
          input :zip_code
          input :phone_number
          input :mobile_phone_number
          input :latitude
          input :longitude
          input :website_url
          input :website_url_text
          input :availability_url
          input :resident_link_text
          input :resident_link_url
          input :video_url
          input :facebook_url
          input :twitter_account
          input :brochure_link_text
          input :brochure_type, as: :select, collection: Property::BROCHURE_TYPE
          input :brochure
          input :brochure_url
          input :schedule_tour_url
          input :local_info_feed
          input :listing_image, as: :image
          input :listing_title
          input :listing_text # TODO WYSIWYG
          input :neighborhood_listing_image, as: :image
          input :neighborhood_description
          input :hero_image, as: :image
          input :overview_title
          input :overview_text # TODO WYSIWYG
          input :overview_bullet_1
          input :overview_bullet_2
          input :overview_bullet_3
          input :promo
          input :core_id
          input :included_in_export
          input :published
          input :featured
        end

        tab 'Floor Plans' do
          association_table_for :floor_plans, reorderable: true do
            column :name
            column :bedrooms
            column :bathrooms
            column :square_footage
            column :availability
            column :featured
          end
        end

        tab 'Features' do
          input :property_features, label: 'Property Features'
        end

        tab 'Amenities' do
          has_many :property_amenities, heading: false, allow_destroy: true, new_record: 'Add Amenity' do |amenity|
            amenity.input :primary_type, as: :select, collection: PropertyAmenity::PRIMARY_TYPE
            amenity.input :sub_type,     as: :select, collection: PropertyAmenity::SUB_TYPE
            amenity.input :description
          end
        end

        tab 'Pages' do
          panel nil do
            insert_tag ActiveAdmin::Views::IndexAsTable::IndexTableFor, pages do
              column nil do |page|
                page.class.name.to_s.gsub('Property', '').titleize
              end

              column nil, class: 'col-actions' do |page|
                div class: 'table_actions' do
                  if page.persisted?
                    link_to I18n.t('active_admin.view'), polymorphic_url([:new_admin, page])
                    link_to I18n.t('active_admin.edit'), polymorphic_url([:edit, :new_admin, page])
                    link_to I18n.t('active_admin.delete'), polymorphic_url([:new_admin, page]), method: :delete, data: { confirm: I18n.t('active_admin.delete_confirmation') }
                  else
                    link_to "Add New", polymorphic_url([:new, :new_admin, page.class.model_name.singular_route_key]), class: "button"
                  end
                end
              end
            end
          end
        end

        tab 'Media' do
          panel 'Slideshow' do
            association_table_for :slideshow do
              column :name
            end
          end

          panel 'Videos' do
            association_table_for :videos, reorderable: true do
              column 'URL' do |video|
                link_to video.url, video.url, target: :blank
              end
            end
          end

          panel 'Photos' do
            association_table_for :photos, reorderable: true do
              column nil do |photo|
                image_tag photo.image.url(:thumb)
              end
              column :title
              column :photo_group
            end
          end
        end

        tab 'Office Hours' do
          has_many :office_hours, heading: false, allow_destroy: true do |office_hour|
            office_hour.input :day, as: :select, collection: OfficeHour::DAY
            office_hour.input :closed
            office_hour.input :opens_at
            office_hour.input :opens_at_period, as: :select, collection: OfficeHour::OPENS_AT_PERIOD
            office_hour.input :closes_at
            office_hour.input :closes_at_period, as: :select, collection: OfficeHour::CLOSES_AT_PERIOD
          end
        end

        tab 'Contact-Related' do
          input :hyly_id
          input :show_lead_2_lease
          input :lead_2_lease_email
          input :lead_2_lease_id
          input :under_construction
          inputs for: [:contact_configuration, f.object.contact_configuration || ApartmentContactConfiguration.new(apartment_community: f.object)] do |contact_config|
            contact_config.input :upcoming_intro_text
            contact_config.input :upcoming_thank_you_text
          end
        end

        tab 'SEO' do
          input :meta_title
          input :meta_description
          input :meta_keywords
          input :media_meta_title
          input :media_meta_description
          input :media_meta_keywords
          input :floor_plans_meta_title
          input :floor_plans_meta_description
          input :floor_plans_meta_keywords
          input :seo_link_text
          input :seo_link_url
        end

        tab 'Codes' do
          panel 'DNR' do
            inputs for: [:dnr_configuration, f.object.dnr_configuration || DnrConfiguration.new(property: f.object)] do |dnr|
              dnr.input :customer_code
            end
          end

          panel 'Mediaplex' do
            inputs for: [:mediaplex_tag, f.object.mediaplex_tag || MediaplexTag.new(trackable: f.object)] do |tag|
              # TODO Re-implement the Mediaplex Parser here
              tag.input :page_name
              tag.input :roi_name
            end
          end

          input :ufollowup_id
          input :show_rtrk_code
        end
      end

      actions
    end
  end

  controller do
    def find_resource
      ApartmentCommunity.friendly.find(params[:id])
    end

    def scoped_collection
      ApartmentCommunity.includes(city: [:state])
    end

    def cities
      @cities ||= City.includes(:state)
    end
    helper_method :cities

    def counties
      @counties ||= County.includes(:cities, :state)
    end

    def pages
      @pages ||= Community::PAGES.map do |page_type|
        resource.send(page_type).presence || "Property#{page_type.to_s.classify}".constantize.new(property: resource)
      end
    end
    helper_method :pages
  end
end
