ActiveAdmin.register Hospital do
  menu parent: 'Neighborhoods'

  track_changes

  config.sort_order = 'position_asc'

  reorderable

  permit_params :name,
                :hospital_region_id,
                :position,
                :latitude,
                :longitude,
                :listing_image,
                :description,
                :detail_description,
                hospital_memberships_attributes: [
                  :id,
                  :hospital_id,
                  :apartment_community_id,
                  :_destroy
                ]

  filter :name_cont, label: 'Name'


  index do
    column :name

    actions
  end

  show do |hospital|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for resource do
            row :id
            row :name
            row :slug
            row :latitude
            row :longitude
            row :detail_description
            row :listing_image do |hospital|
              if hospital.listing_image.present?
                image_tag hospital.listing_image
              end
            end
            row :hospital_region
            row :latitude
            row :longitude
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Apartment Communities' do
        collection_panel_for :hospital_memberships do
          reorderable_table_for hospital.hospital_memberships.order(:position)  do
            column :position
            column :apartment_community
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
          input :hospital_region,               as: :chosen
          input :latitude
          input :longitude
          input :listing_image,       as: :image, required: true
          input :description
          input :detail_description
        end

        tab 'Apartment Communities' do
          has_many :hospital_memberships, allow_destroy: true, new_record: 'Add Community', heading: false do |membership|
            membership.input :apartment_community, as: :chosen
          end
        end 

      end

      actions
    end
  end

  controller do
    def find_resource
      Hospital.friendly.find(params[:id])
    end
  end
end
