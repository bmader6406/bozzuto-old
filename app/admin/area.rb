ActiveAdmin.register Area do
  menu parent: 'Neighborhoods'

  track_changes

  config.sort_order = 'position_asc'

  reorderable

  permit_params :name,
                :metro,
                :metro_id,
                :state,
                :state_id,
                :latitude,
                :longitude,
                :banner_image,
                :listing_image,
                :description,
                :detail_description,
                :area_type,
                :position,
                related_areas_attributes: [
                  :id,
                  :area_id,
                  :nearby_area_id,
                  :_destroy
                ],
                seo_metadata_attributes: [
                  :id,
                  :meta_title,
                  :meta_description,
                  :meta_keywords
                ],
                area_memberships_attributes: [
                  :id,
                  :area_id,
                  :apartment_community_id,
                  :_destroy
                ]

  filter :name_cont, label: 'Search'

  index do
    column :name

    actions
  end

  show do |area|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for area do
            row :id
            row :name
            row :slug
            row :description
            row :detail_description
            row :banner_image do |area|
              if area.banner_image.present?
                image_tag area.banner_image
              end
            end
            row :listing_image do |area|
              if area.listing_image.present?
                image_tag area.listing_image
              end
            end
            row :metro
            row :state
            row :latitude
            row :longitude
            row :area_type
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Apartment Communities' do
        collection_panel_for :area_memberships do
          reorderable_table_for area.area_memberships do
            column :apartment_community
          end
        end
      end

      tab 'Related Areas' do
        collection_panel_for :related_areas do
          reorderable_table_for resource.related_areas do
            column :nearby_area
          end
        end
      end

      tab 'Seo' do
        collection_panel_for :seo_metadata do
          attributes_table_for resource.seo_metadata do
            row :meta_title
            row :meta_description
            row :meta_keywords
          end
        end
      end

      tab 'Neighborhoods' do
        collection_panel_for :neighborhoods do
          table_for area.neighborhoods do
            column :name do |neighborhood|
              link_to neighborhood.name, [:admin, neighborhood]
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
          input :name
          input :metro,               as: :chosen
          input :state,               as: :chosen
          input :latitude
          input :longitude
          input :banner_image,        as: :image
          input :listing_image,       as: :image, required: true
          input :description
          input :detail_description
          input :area_type,           as: :chosen, collection: Area::AREA_TYPE
        end

        tab 'Apartment Communities' do
          has_many :area_memberships, allow_destroy: true, new_record: 'Add Community', heading: false do |membership|
            membership.input :apartment_community, as: :chosen
          end
        end

        tab 'Related Areas' do
          has_many :related_areas, allow_destroy: true, new_record: 'Add Related Area', heading: false do |area|
            area.input :nearby_area
          end
        end

        tab 'Seo' do
          inputs for: [:seo_metadata, f.object.seo_metadata || SeoMetadata.new(resource: resource)] do |seo|
            seo.input :meta_title
            seo.input :meta_description
            seo.input :meta_keywords
          end
        end

        tab 'Neighborhoods' do
          association_table_for :neighborhoods do
            column :name
          end
        end
      end

      actions
    end
  end

  controller do
    def find_resource
      Area.friendly.find(params[:id])
    end
  end
end
