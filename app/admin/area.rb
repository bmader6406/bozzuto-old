ActiveAdmin.register Area do
  menu parent: 'Neighborhoods'

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
                ]

  filter :name_cont, label: 'Search'

  index do
    column :name

    actions
  end

  show do
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for resource do
            row :name
            row :slug
            row :description
            row :detail_description
            row :banner_image do |area|
              if area.banner_image
                image_tag area.banner_image
              end
            end
            row :listing_image do |area|
              if area.listing_image
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

      tab 'Related Areas' do
        collection_panel_for :related_areas do
          reorderable_table_for resource.related_areas do
            column :nearby_area
          end
        end
      end

      tab 'SEO Metadata' do
        collection_panel_for :seo_metadata do
          attributes_table_for resource.seo_metadata do
            row :meta_title
            row :meta_description
            row :meta_keywords
          end
        end
      end
    end
  end

  form do |f|
    inputs do
      tabs do
        tab 'Main' do
          input :name
          input :metro
          input :state
          input :latitude
          input :longitude
          input :banner_image
          input :listing_image
          input :description
          input :detail_description
          input :area_type, as: :select, collection: Area::AREA_TYPE
        end

        tab 'Related Areas' do
          has_many :related_areas, allow_destroy: true, new_record: 'Add Related Area', heading: false do |area|
            area.input :nearby_area
          end
        end

        tab 'SEO Metadata' do
          inputs for: [:seo_metadata, f.object.seo_metadata || SeoMetadata.new(resource: resource)] do |seo|
            seo.input :meta_title
            seo.input :meta_description
            seo.input :meta_keywords
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
