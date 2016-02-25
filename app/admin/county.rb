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

  show do
    attributes_table do
      row :name
      row :state
      row :created_at
      row :updated_at
    end

    panel 'Cities' do
      if resource.cities.any?
        table_for resource.cities do
          column :name do |city|
            link_to city.name, [:new_admin, city]
          end
        end
      end
    end
  end

  form do |f|
    inputs do
      input :name
      input :state, as: :chosen

      actions
    end
  end

  controller do
    def scoped_collection
      County.includes(:state)
    end
  end
end
