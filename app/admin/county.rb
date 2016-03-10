ActiveAdmin.register County do
  config.sort_order = 'name_asc'

  menu parent: 'Geography'

  permit_params :name,
                :state

  filter :name_cont, label: 'Name'

  index do
    column :name
    column :state, sortable: 'states.name'

    actions
  end

  show do |county|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for county do
            row :id
            row :name
            row :state
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Cities' do
        collection_panel_for :cities do
          table_for county.cities do
            column :name do |city|
              link_to city.name, [:admin, city]
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
          input :state, as: :chosen
        end

        tab 'Cities' do
          association_table_for :cities do
            column :name
          end
        end
      end

      actions
    end
  end

  controller do
    def scoped_collection
      County.includes(:state)
    end
  end
end
