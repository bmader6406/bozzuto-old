ActiveAdmin.register LassoAccount do
  menu parent: 'Contact'

  permit_params :property_id,
                :uid,
                :client_id,
                :project_id,
                :analytics_id

  filter :uid_or_client_id_or_project_id_cont, label: 'Search'
  filter :property, as: :select, collection: -> { HomeCommunity.all }

  index do
    column :uid
    column :client_id
    column :project_id
    column :property

    actions
  end

  show do
    attributes_table do
      row :property
      row :uid
      row :client_id
      row :project_id
      row :analytics_id
    end
  end

  form do |f|
    inputs do
      input :property, collection: HomeCommunity.all
      input :uid
      input :client_id
      input :project_id
      input :analytics_id

      actions
    end
  end
end
