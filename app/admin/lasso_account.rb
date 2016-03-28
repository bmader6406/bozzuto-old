ActiveAdmin.register LassoAccount do
  menu parent: 'Components'

  track_changes

  permit_params :home_community_id,
                :uid,
                :client_id,
                :project_id,
                :analytics_id

  filter :uid_or_client_id_or_project_id_cont, label: 'Search'
  filter :home_community, as: :select

  index do
    column :uid
    column :client_id
    column :project_id
    column :home_community

    actions
  end

  show do
    attributes_table do
      row :id
      row :home_community
      row :uid
      row :client_id
      row :project_id
      row :analytics_id
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs do
      input :home_community, as: :chosen
      input :uid
      input :client_id
      input :project_id
      input :analytics_id

      actions
    end
  end
end
