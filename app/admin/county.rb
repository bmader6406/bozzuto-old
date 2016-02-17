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

  form do |f|
    inputs do
      input :name
      input :state

      actions
    end
  end

  controller do
    def scoped_collection
      County.includes(:state)
    end
  end
end
