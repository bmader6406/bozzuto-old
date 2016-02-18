ActiveAdmin.register Feed do
  menu parent: 'Ronin'

  permit_params :name, :url

  filter :name_or_url_cont, label: 'Search'

  index do
    column :name
    column :url

    actions
  end

  form do |f|
    inputs do
      input :name
      input :url

      actions
    end
  end
end
