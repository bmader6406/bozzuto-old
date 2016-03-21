ActiveAdmin.register ApartmentCommunity do
  config.sort_order = 'title_asc'

  menu parent: 'Properties', label: 'Apartment Communities'

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
                :twitter_account_id,
                :brochure_link_text,
                :brochure_type,
                :brochure,
                :brochure_url,
                :schedule_tour_url,
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
                property_feature_ids: [],
                contact_configuration_attributes: [
                  :id,
                  :apartment_community_id,
                  :upcoming_intro_text,
                  :upcoming_thank_you_text
                ],
                dnr_configuration_attributes: [
                  :id,
                  :property_id,
                  :property_type,
                  :customer_code
                ],
                mediaplex_tag_attributes: [
                  :id,
                  :trackable_id,
                  :trackable_type,
                  :page_name,
                  :roi_name
                ]

  scope :all, default: true
  scope :duplicates

  filter :title_cont,          label: 'Title'
  filter :street_address_cont, label: 'Street Address'
  filter :city,                collection: City.includes(:state)
  filter :published
  filter :featured
  filter :included_in_export
  filter :external_cms_type,
    label:      'Managed By',
    as:         :select,
    collection: Bozzuto::ExternalFeed::SOURCES.map { |feed| [I18n.t("bozzuto.feeds.#{feed}"), feed] }

  action_item :custom_actions, only: :show do
    dropdown_menu 'Custom Apartment Community Actions' do
      item 'Preview', [resource], target: :blank
      item 'Delete All Floor Plans', [:delete_floor_plans, :admin, resource]

      if resource.managed_externally?
        item "Disconnect from #{feed_name}", [:disconnect, :admin, resource]
      else
        item 'Merge with a Feed Property', [:merge_form, :admin, resource]
      end
    end
  end

  action_item :export_field_audit, only: :index do
    link_to 'Export Field Audit', [:export_field_audit, :admin, :apartment_communities]
  end

  action_item :export_dnr, only: :index do
    link_to 'Export DNR', [:export_dnr, :admin, :apartment_communities]
  end

  collection_action :export_field_audit do
    csv_string = Bozzuto::ApartmentCommunityFieldAudit.audit_csv
    send_data csv_string, filename: 'apartment_communities_field_audit.csv', type: :csv
  end

  collection_action :export_dnr do
    send_file Bozzuto::DnrCsv.new(conditions: { published: true }).file
  end

  member_action :delete_floor_plans do
    resource.floor_plans.destroy_all

    redirect_to [:admin, resource], notice: 'Deleted all floor plans.'
  end

  member_action :disconnect do
    cached_feed_name = feed_name

    resource.disconnect_from_external_cms!

    redirect_to [:admin, resource], notice: "Successfully disconnected from #{cached_feed_name}"
  end

  member_action :merge_form
  member_action :pre_merge, method: :put
  member_action :merge, method: :put do
    property_merger.merge!

    redirect_to [:admin, property_merger.property], notice: property_merger.to_s
  end

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
            row :id
            row :title
            row :slug
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
            row :brochure
            row :brochure_url
            row :schedule_tour_url
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
            row :overview_text do |community|
              raw community.overview_text
            end
            row :overview_bullet_1
            row :overview_bullet_2
            row :overview_bullet_3
            row :promo
            row :core_id
            row :included_in_export do |community|
              status_tag community.included_in_export
            end
            row :published do |community|
              status_tag community.published
            end
            row :featured do |community|
              status_tag community.featured
            end
            row :created_at
            row :updated_at
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
              link_to page.class.name.to_s.gsub('Property', '').titleize, polymorphic_url([:admin, page])
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
            row :show_lead_2_lease do |community|
              status_tag community.show_lead_2_lease
            end
            row :lead_2_lease_email
            row :lead_2_lease_id
            row :under_construction do |community|
              status_tag community.under_construction
            end
            row :upcoming_intro_text do |community|
              community.contact_configuration.try(:upcoming_intro_text)
            end
            row :upcoming_thank_you_text do |community|
              community.contact_configuration.try(:upcoming_thank_you_text)
            end
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
              status_tag community.show_rtrk_code
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
          input :city,                        as: :chosen, collection: cities
          input :county,                      as: :chosen
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
          input :twitter_account,             as: :chosen
          input :brochure_link_text
          input :brochure_type,               as: :chosen, collection: Property::BROCHURE_TYPE
          input :brochure
          input :brochure_url
          input :schedule_tour_url
          input :listing_image,               as: :image
          input :listing_title
          input :listing_text,                as: :redactor
          input :neighborhood_listing_image,  as: :image
          input :neighborhood_description
          input :hero_image,                  as: :image
          input :overview_title
          input :overview_text,               as: :redactor
          input :overview_bullet_1
          input :overview_bullet_2
          input :overview_bullet_3
          input :promo,                       as: :chosen
          input :core_id
          input :included_in_export
          input :published
          input :featured
        end

        tab 'Floor Plans' do
          association_table_for :floor_plans, reorderable: true do
            column :name do |plan|
              link_to plan.name, [:admin, plan], target: :blank
            end
            column :bedrooms
            column :bathrooms
            column :square_footage
            column :availability
            column :featured
          end
        end

        tab 'Features' do
          input :property_features, label: 'Property Features', as: :chosen
        end

        tab 'Amenities' do
          association_table_for :property_amenities do
            column :primary_type
            column :sub_type
            column :description
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
                    link_to(I18n.t('active_admin.view'), polymorphic_url([:admin, page]), target: :blank) +
                    link_to(I18n.t('active_admin.edit'), polymorphic_url([:edit, :admin, page]), target: :blank) +
                    link_to(I18n.t('active_admin.delete'), polymorphic_url([:admin, page]), method: :delete, data: { confirm: I18n.t('active_admin.delete_confirmation') })
                  else
                    options = { page.class.model_name.singular_route_key => { property_id: resource.id, property_type: 'ApartmentCommunity' } }
                    link_to "Add New", polymorphic_url([:new, :admin, page.class.model_name.singular_route_key], options), class: 'button', target: :blank
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
          association_table_for :office_hours do
            column('') { |hour| hour.to_s }
          end
        end

        tab 'Contact-Related' do
          input :hyly_id
          input :show_lead_2_lease
          input :lead_2_lease_email
          input :lead_2_lease_id
          input :under_construction
          inputs for: [:contact_configuration, f.object.contact_configuration || ApartmentContactConfiguration.new(apartment_community: f.object)] do |contact_config|
            contact_config.input :upcoming_intro_text, as: :redactor
            contact_config.input :upcoming_thank_you_text, as: :redactor
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
    before_action :strip_empty_dnr_config, only: [:create, :update]

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

    def feed_name
      resource.external_cms_name
    end
    helper_method :feed_name

    def property_merger
      @property_merger ||= Bozzuto::PropertyMerger.new(resource).process(params)
    end
    helper_method :property_merger

    def strip_empty_dnr_config
      if resource_params.first['dnr_configuration_attributes']['customer_code'].empty?
        resource_params.first.delete('dnr_configuration_attributes')
      end
    end
  end
end
