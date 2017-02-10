ActiveAdmin.register SearchResultProxy do
  config.sort_order = 'query_asc'

  menu parent: 'System'

  permit_params :query, :url

  filter :query_cont, label: 'Name (contains)'
  filter :url_cont, label: "URL (contains)"

  index do
    column :query
    column :url

    actions
  end

  show title: :query do |search_proxy|
    panel nil do
      attributes_table_for search_proxy do
        row :id
        row :query
        row :url
        row :created_at
        row :updated_at
      end
    end
  end

  form do |f|
    inputs do
      input :query
      input :url

      actions
    end
  end

end
