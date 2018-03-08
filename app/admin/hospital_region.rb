ActiveAdmin.register HospitalRegion do
  menu parent: 'Neighborhoods'

  track_changes

  # config.sort_order = 'position_asc'

  # reorderable

  permit_params :name,
                :latitude,
                :longitude,
                :detail_description

  filter :name_cont, label: 'Name'

  # Work around for models who have overridden `to_param` in AA
  # See SO issue:
  # http://stackoverflow.com/questions/7684644/activerecordreadonlyrecord-when-using-activeadmin-and-friendly-id
  before_filter do
    HospitalRegion.class_eval do
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
            row :id
            row :name
            row :slug
            row :latitude
            row :longitude
            row :detail_description
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Hospitals' do
        collection_panel_for :hospitals do
          reorderable_table_for resource.hospitals.position_asc do
            column :name do |a|
              link_to a.name, [:admin, a]
            end
          end
        end
      end

      tab 'Hospital Region Blog' do
        collection_panel_for :hospital_blog do
          attributes_table_for resource.hospital_blog do
            row :id
            row :title
            row :url
            row :listing_image do |blog|
              if blog.listing_image.present?
                image_tag blog.listing_image
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
          input :detail_description
        end

        tab 'Hospitals' do 
          panel nil do
            association_table_for :hospitals, scope: resource.hospitals.position_asc do
              column :name
            end
          end
        end

        tab 'Hospital Region Blog' do 
          panel nil do
            association_table_for :hospital_blog, scope: resource.hospital_blog do
              column :title
            end
          end
        end

      end
    end

    actions
  end
end
