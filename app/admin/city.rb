ActiveAdmin.register City do
  config.sort_order = 'name_asc'

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
    attributes_table do
      row :name
      row :state
      row :created_at
      row :updated_at
    end

    panel 'Counties' do
      if city.counties.any?
        table_for city.counties do
          column :name do |county|
            link_to county.name, [:new_admin, county]
          end
          column :state
        end
      end
    end
  end

  form do |f|
    inputs do
      input :name
      input :state,    as: :chosen
      input :counties, as: :chosen, collection: County.order(:name)

      actions
    end
  end

  controller do
    def scoped_collection
      City.includes(:state)
    end
  end
end
