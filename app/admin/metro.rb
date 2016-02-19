ActiveAdmin.register Metro do
  menu parent: 'Neighborhoods'

  permit_params :name,
                :latitude,
                :longitude,
                :banner_image,
                :listing_image,
                :detail_description,
                :position

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
              if resource.banner_image
                image_tag resource.banner_image
              end
            end
            row :listing_image do
              if resource.listing_image
                image_tag resource.listing_image
              end
            end
            rows :detail_description
            rows :created_at, :updated_at
          end
        end
      end

      tab 'Areas' do
        collection_panel_for :areas do
          reorderable_table_for resource.areas do
            column :name do |a|
              link_to a.name, [:new_admin, a]
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
          input :detail_description
        end

        tab 'Areas' do 
          panel nil do
            association_table_for :areas do
              column :name
            end
          end
        end
      end
    end

    actions
  end
end
