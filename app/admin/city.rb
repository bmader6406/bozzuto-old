ActiveAdmin.register City do
  config.sort_order = 'name_asc'

  track_changes

  menu parent: 'Geography'

  permit_params :name,
                :state_id,
                :county_ids

  filter :name_cont, label: 'Name'

  index do
    column :name
    column :state, sortable: 'states.name'

    actions
  end

  show do |city|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for city do
            row :id
            row :name
            row :state
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Counties' do
        collection_panel_for :counties do
          table_for city.counties do
            column :name do |county|
              link_to county.name, [:admin, county]
            end
            column :state
          end
        end
      end

      tab 'Apartment Communities' do
        collection_panel_for :apartment_communities do
          table_for city.apartment_communities do
            column :title
            column :published
            column :featured
            column :street_address
          end
        end
      end
    end
  end

  form do |f|
    inputs do
      input :name
      input :state,    as: :chosen
      input :counties, as: :chosen, collection: County.ordered_by_name

      actions
    end
  end

  controller do
    def scoped_collection
      City.includes(:state)
    end
  end
end
