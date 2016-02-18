ActiveAdmin.register HomeNeighborhood do
  config.sort_order = 'position_asc'

  reorderable

  menu parent: 'Neighborhoods'

  permit_params :name,
                :latitude,
                :longitude,
                :banner_image,
                :listing_image,
                :description,
                :detail_description,
                :featured_home_community_id

  filter :name_or_description_cont, label: 'Search'

  index as: :reorderable_table do
    column :name
    
    actions
  end

  show do
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for resource do
            row :name
            row :latitude
            row :longitude
            row :description
            row :detail_description
            row :banner_image do |neighborhood|
              if neighborhood.banner_image
                image_tag neighborhood.banner_image
              end
            end
            row :listing_image do |neighborhood|
              if neighborhood.listing_image
                image_tag neighborhood.listing_image
              end
            end
            row :featured_home_community
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'SEO Metadata' do
        panel nil do
          if resource.seo_metadata.present?
            attributes_table_for resource.seo_metadata do
              row :meta_title
              row :meta_description
              row :meta_keywords
            end
          else
            div class: 'blank_slate_container' do
              span class: 'blank_slate' do
                span 'No SEO Metadata'
              end
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
          input :latitude
          input :longitude
          input :banner_image
          input :listing_image
          input :description
          input :detail_description
          input :featured_home_community
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
      HomeNeighborhood.friendly.find(params[:id])
    end
  end
end
