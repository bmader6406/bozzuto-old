ActiveAdmin.register Neighborhood do
  menu parent: 'Neighborhoods',
       label:  'Neighborhoods'

  track_changes

  config.sort_order = 'position_asc'

  reorderable

  permit_params :name,
                :area,
                :area_id,
                :state,
                :state_id,
                :latitude,
                :longitude,
                :banner_image,
                :listing_image,
                :description,
                :detail_description,
                :featured_apartment_community,
                :featured_apartment_community_id,
                seo_metadata_attributes: [
                  :id,
                  :meta_title,
                  :meta_description,
                  :meta_keywords
                ],
                neighborhood_memberships_attributes: [
                  :id,
                  :neighborhood_id,
                  :apartment_community_id,
                  :_destroy
                ],
                related_neighborhoods_attributes: [
                  :id,
                  :neighborhood_id,
                  :nearby_neighborhood_id,
                  :_destroy
                ]

  filter :name_cont, label: 'Name'

  # Work around for models who have overridden `to_param` in AA
  # See SO issue:
  # http://stackoverflow.com/questions/7684644/activerecordreadonlyrecord-when-using-activeadmin-and-friendly-id
  before_filter do
    Neighborhood.class_eval do
      def to_param
        id.to_s
      end
    end
  end

  index do
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
            row :area
            row :state
            row :latitude
            row :longitude
            row :banner_image do
              if neighborhood.banner_image.present?
                image_tag neighborhood.banner_image.url
              end
            end
            row :listing_image do
              if neighborhood.listing_image.present?
                image_tag neighborhood.listing_image.url
              end
            end
            row :description
            row :detail_description
            row :featured_apartment_community
            row :created_at
            row :updated_at
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

      tab 'Neighborhood Memberships' do
        collection_panel_for :neighborhood_memberships do
          table_for neighborhood.neighborhood_memberships do
            column :apartment_community
          end
        end
      end

      tab 'Related Neighborhoods' do
        collection_panel_for :related_neighborhoods do
          reorderable_table_for resource.related_neighborhoods do
            column :nearby_neighborhood
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
          input :area,                         as: :chosen
          input :state,                        as: :chosen
          input :latitude
          input :longitude
          input :banner_image,                 as: :image, required: true
          input :listing_image,                as: :image, required: true
          input :description
          input :detail_description
          input :featured_apartment_community, as: :chosen
        end

        tab 'Seo' do
          inputs for: [:seo_metadata, f.object.seo_metadata || SeoMetadata.new(resource: resource)] do |seo|
            seo.input :meta_title
            seo.input :meta_description
            seo.input :meta_keywords
          end
        end

        tab 'Neighborhood Memberships' do
          has_many :neighborhood_memberships, allow_destroy: true, new_record: 'Add Community', heading: false do |membership|
            membership.input :apartment_community
          end
        end

        tab 'Related Neighborhoods' do
          has_many :related_neighborhoods, allow_destroy: true, new_record: 'Add Related Neighborhood', heading: false do |neighborhood|
            neighborhood.input :nearby_neighborhood
          end
        end
      end
    end

    actions
  end
end
