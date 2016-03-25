ActiveAdmin.register State do
  menu parent: 'Geography'

  track_changes

  config.sort_order = 'position_asc'

  reorderable

  permit_params :name,
                :code,
                :position,
                seo_metadata_attributes: [
                  :id,
                  :meta_title,
                  :meta_description,
                  :meta_keywords
                ]

  filter :name_cont, label: "Name"

  # Work around for models who have overridden `to_param` in AA
  # See SO issue:
  # http://stackoverflow.com/questions/7684644/activerecordreadonlyrecord-when-using-activeadmin-and-friendly-id
  before_filter do
    State.class_eval do
      def to_param
        id.to_s
      end
    end
  end

  index as: :reorderable_table do
    column :name
    column :code

    actions
  end

  show do
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for resource do
            row :id
            row :name
            row :code
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

      tab 'Cities' do
        collection_panel_for :cities do
          table_for resource.cities.includes(:counties) do
            column :name do |city|
              link_to city.name, [:admin, city]
            end
            column :counties do |city|
              if city.counties.any?
                ul do
                  city.counties.each do |county|
                    li { county }
                  end
                end
              end
            end
          end
        end
      end

      tab 'Counties' do
        collection_panel_for :counties do
          table_for resource.counties.includes(:cities) do
            column :name do |county|
              link_to county.name, [:admin, county]
            end
            column :cities do |county|
              if county.cities.any?
                ul do
                  county.cities.each do |city|
                    li { city.name }
                  end
                end
              end
            end
          end
        end
      end

      tab 'Featured Apartment Communities' do
        collection_panel_for :featured_apartment_communities do
          table_for resource.featured_apartment_communities do
            column :featured_position
            column :title do |community|
              link_to community.title, [:admin, community]
            end
            column :published
            column :featured
            column :city
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
          input :code
        end

        tab 'Seo' do
          inputs for: [:seo_metadata, f.object.seo_metadata || SeoMetadata.new(resource: resource)] do |seo|
            seo.input :meta_title
            seo.input :meta_description
            seo.input :meta_keywords
          end
        end

        tab 'Cities' do
          association_table_for :cities do
            column :name
          end
        end

        tab 'Counties' do
          association_table_for :counties do
            column :name
          end
        end

        tab 'Featured Apartment Communities' do
          association_table_for :featured_apartment_communities do
            column :title
            column :published
            column :featured
            column :city
          end
        end
      end
    end

    actions
  end
end
