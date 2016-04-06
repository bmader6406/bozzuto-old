ActiveAdmin.register HomeCommunity do
  config.sort_order = 'title_asc'

  track_changes

  menu parent: 'Properties', label: 'Home Communities'

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
                :website_url,
                :website_url_text,
                :video_url,
                :facebook_url,
                :twitter_account,
                :brochure_link_text,
                :brochure,
                :brochure_url,
                :listing_image,
                :listing_promo,
                :listing_title,
                :listing_text,
                :neighborhood_listing_image,
                :neighborhood_description,
                :meta_title,
                :meta_description,
                :meta_keywords,
                :overview_title,
                :overview_text,
                :overview_bullet_1,
                :overview_bullet_2,
                :overview_bullet_3,
                :promo_id,
                :secondary_lead_source_id,
                :media_meta_title,
                :media_meta_description,
                :media_meta_keywords,
                :floor_plans_meta_title,
                :floor_plans_meta_description,
                :floor_plans_meta_keywords,
                :published,
                property_features_ids: [],
                dnr_configuration_attributes: [
                  :id,
                  :property_id,
                  :property_type,
                  :customer_code
                ],
                conversion_configuration_attributes: [
                  :id,
                  :name,
                  :home_community_id,
                  :google_send_to_friend_label,
                  :google_send_to_phone_label,
                  :google_contact_label,
                  :bing_send_to_friend_action_id,
                  :bing_send_to_phone_action_id,
                  :bing_contact_action_id
                ]

  filter :title_cont,          label: 'Title'
  filter :street_address_cont, label: 'Street Address'
  filter :city,                collection: City.includes(:state)
  filter :published

  action_item :export_field_audit, only: :index do
    link_to 'Export Field Audit', [:export_field_audit, :admin, :home_communities]
  end

  action_item :preview, only: :show, if: -> { resource.published? } do
    link_to 'Preview', resource, target: :blank
  end

  collection_action :export_field_audit do
    send_data Bozzuto::HomeCommunityFieldAudit.audit_csv, filename: 'home_communities_field_audit.csv', type: :csv
  end

  index do
    column :title
    column :street_address
    column :city
    column :published

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
            row :video_url
            row :facebook_url
            row :twitter_account
            row :brochure_link_text
            row :brochure
            row :brochure_url
            row :listing_image do |community|
              if community.listing_image.present?
                image_tag community.listing_image
              end
            end
            row :listing_promo do |community|
              if community.listing_promo.present?
                image_tag community.listing_promo
              end
            end
            row :listing_title
            row :listing_text do |community|
              raw community.listing_text
            end
            row :neighborhood_listing_image do |community|
              if community.neighborhood_listing_image.present?
                image_tag community.neighborhood_listing_image
              end
            end
            row :neighborhood_description
            row :overview_title
            row :overview_text do |community|
              raw community.overview_text
            end
            row :overview_bullet_1
            row :overview_bullet_2
            row :overview_bullet_3
            row :promo
            row :published do |community|
              status_tag community.published
            end
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Homes' do
        collection_panel_for :homes do
          reorderable_table_for community.homes do
            column :name
            column :bedrooms
            column :bathrooms
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

      tab 'Lasso Account' do
        collection_panel_for :lasso_account do
          attributes_table_for community.lasso_account do
            row :uid
            row :client_id
            row :project_id
            row :analytics_id
          end
        end
      end

      tab 'Contact-Related' do
        panel nil do
          attributes_table_for community do
            row :secondary_lead_source_id
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
          end
        end
      end

      tab 'Codes' do
        panel nil do
          attributes_table_for community do
            row 'DNR Customer Code' do |community|
              community.dnr_configuration.try(:customer_code)
            end
          end
        end

        panel 'Conversion Configuration' do
          attributes_table_for community.conversion_configuration do
            row :name
            row :google_send_to_friend_label
            row :google_send_to_phone_label
            row :google_contact_label
            row :bing_send_to_friend_action_id
            row :bing_send_to_phone_action_id
            row :bing_contact_action_id
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
          input :video_url
          input :facebook_url
          input :twitter_account,             as: :chosen
          input :brochure_link_text
          input :brochure
          input :brochure_url
          input :listing_image,               as: :image
          input :listing_promo,               as: :image
          input :listing_title
          input :listing_text,                as: :redactor
          input :neighborhood_listing_image,  as: :image
          input :neighborhood_description
          input :overview_title
          input :overview_text,               as: :redactor
          input :overview_bullet_1
          input :overview_bullet_2
          input :overview_bullet_3
          input :promo,                       as: :chosen, label: ('Promo ' + link_to('(Add New)', [:new, :admin, :promo], target: :blank)).html_safe
          input :published
        end

        tab 'Homes' do
          association_table_for :homes, reorderable: true do
            column :name
            column :bedrooms
            column :bathrooms
            column :featured
          end
        end

        tab 'Features' do
          input :property_features, as: :chosen, label: 'Property Features'
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
                    options = { page.class.model_name.singular_route_key => { property_id: resource.id, property_type: 'HomeCommunity' } }
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

        tab 'Lasso Account' do
          association_table_for :lasso_account do
            column('Lasso UID')        { |account| account.uid }
            column('Lasso Client ID')  { |account| account.client_id }
            column('Lasso Project ID') { |account| account.project_id }
          end
        end

        tab 'Contact-Related' do
          input :secondary_lead_source_id
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
        end

        tab 'Codes' do
          panel 'DNR' do
            inputs for: [:dnr_configuration, f.object.dnr_configuration || DnrConfiguration.new(property: f.object)] do |dnr|
              dnr.input :customer_code
            end
          end

          panel 'Conversion Configuration' do
            inputs for: [:conversion_configuration, f.object.conversion_configuration || ConversionConfiguration.new(home_community: f.object)] do |conversion|
              conversion.input :name
              conversion.input :google_send_to_friend_label
              conversion.input :google_send_to_phone_label
              conversion.input :google_contact_label
              conversion.input :bing_send_to_friend_action_id
              conversion.input :bing_send_to_phone_action_id
              conversion.input :bing_contact_action_id
            end
          end
        end
      end

      actions
    end
  end

  controller do
    before_action :strip_empty_configurations, only: [:create, :update]

    def find_resource
      HomeCommunity.friendly.find(params[:id])
    end

    def scoped_collection
      HomeCommunity.includes(city: [:state])
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

    def strip_empty_configurations
      strip_empty_dnr_config
      strip_empty_conversion_config
    end

    def strip_empty_dnr_config
      if resource_params.first['dnr_configuration_attributes']['customer_code'].empty?
        resource_params.first.delete('dnr_configuration_attributes')
      end
    end

    def strip_empty_conversion_config
      if resource_params.first['conversion_configuration_attributes']['name'].empty?
        resource_params.first.delete('conversion_configuration_attributes')
      end
    end
  end
end
