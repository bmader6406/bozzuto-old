ActiveAdmin.register City do
  config.sort_order = 'name_asc'

  menu parent: 'Geography'

  permit_params :name,
                :state_id,
                :county_ids

  filter :name_cont, label: 'Name'

  index do
    column :name
    column :state

    actions
  end

  show do |city|
    attributes_table do
      row :name
      row :state
      row :created_at
      row :updated_at
    end

    if city.counties.any?
      panel 'Counties' do
        table_for city.counties do
          column :name
          column :state
        end
      end
    end
  end

  form do |f|
    inputs do
      input :name
      input :state
      input :counties, collection: County.order(:name)

      actions
    end
  end
end
