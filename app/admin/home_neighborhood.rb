ActiveAdmin.register HomeNeighborhood do
  config.sort_order = 'position_asc'

  track_changes

  reorderable

  menu parent: 'Neighborhoods', label: 'Home Neighborhoods'

  permit_params :name,
                :latitude,
                :longitude,
                :banner_image,
                :listing_image,
                :description,
                :detail_description,
                :featured_home_community_id,
                home_neighborhood_memberships_attributes: [
                  :id,
                  :home_neighborhood_id,
                  :home_community_id,
                  :_destroy
                ]

  filter :name_or_description_cont, label: 'Search'

  index as: :reorderable_table do
    column :name
    
    actions
  end

  show do |neighborhood|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for neighborhood do
            row :id
            row :name
            row :slug
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

      tab 'Home Communities' do
        collection_panel_for :home_neighborhood_memberships do
          reorderable_table_for neighborhood.home_neighborhood_memberships do
            column :home_community
          end
        end
      end

      tab 'Seo' do
        collection_panel_for :seo_metadata do
          attributes_table_for neighborhood.seo_metadata do
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
          input :banner_image,            as: :image
          input :listing_image,           as: :image
          input :description
          input :detail_description
          input :featured_home_community, as: :chosen
        end

        tab 'Home Communities' do
          has_many :home_neighborhood_memberships, allow_destroy: true, heading: false, new_record: 'Add Home Community' do |membership|
            membership.input :home_community, as: :chosen
          end
        end

        tab 'Seo' do
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
