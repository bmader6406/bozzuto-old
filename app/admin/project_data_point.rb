ActiveAdmin.register ProjectDataPoint do
  menu false

  reorderable

  permit_params :project,
                :project_id,
                :name,
                :data

  filter :name_cont, label: 'Name'

  index do
    column :project
    column :name
    column :data

    actions
  end

  show do
    attributes_table do
      row :id
      row :project
      row :name
      row :data
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs do
      input :project, as: :chosen
      input :name
      input :data
    end

    actions
  end
end
