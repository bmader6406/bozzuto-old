ActiveAdmin.register Metro do
  menu parent: 'Neighborhoods'

  permit_params :name,
                :latitude,
                :longitude,
                :banner_image,
                :listing_image,
                :detail_description,
                :position,
                seo_metadata_attributes: [
                  :id,
                  :meta_title,
                  :meta_description,
                  :meta_keywords
                ]

  filter :name_cont, label: 'Name'

  # Work around for models who have overridden `to_param` in AA
  # See SO issue:
  # http://stackoverflow.com/questions/7684644/activerecordreadonlyrecord-when-using-activeadmin-and-friendly-id
  before_filter do
    Metro.class_eval do
      def to_param
        id.to_s
      end
    end
  end

  index do
    column :name

    actions
  end

  show do
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for resource do
            rows :id
            rows :name, :slug
            rows :latitude, :longitude
            row :banner_image do
              image_tag resource.banner_image if resource.banner_image
            end
            row :listing_image do
              image_tag resource.listing_image if resource.listing_image
            end
            rows :detail_description
            rows :created_at, :updated_at
          end
        end
      end

      tab 'Areas' do
        collection_panel_for :areas do
          reorderable_table_for resource.areas.position_asc do
            column :position
            column :name do |a|
              link_to a.name, [:new_admin, a]
            end
          end
        end
      end

      tab 'Seo Metadata' do
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
        tab 'Details' do
          input :name
          input :latitude
          input :longitude
          input :banner_image, as: :image
          input :listing_image, as: :image
          input :detail_description, input_html: { rows: 10 }
        end

        tab 'Areas' do 
          panel nil do
            association_table_for :areas, scope: resource.areas.position_asc do
              column :position
              column :name
            end
          end
        end

        tab 'Seo Metadata' do
          inputs for: [:seo_metadata, f.object.seo_metadata || SeoMetadata.new(resource: resource)] do |seo|
            seo.input :meta_title
            seo.input :meta_description
            seo.input :meta_keywords
          end
        end
      end
    end

    actions
  end
end
