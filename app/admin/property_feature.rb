ActiveAdmin.register PropertyFeature do
  menu parent: 'Properties'

  permit_params :name,
                :icon,
                :description,
                :show_on_search_page,
                :position

  filter :name_cont, label: 'Name'

  index do
    column :name
    column :icon

    actions
  end

  form do |f|
    inputs do
      input :name
      input :icon
      input :description
      input :show_on_search_page
    end

    actions
  end
end
