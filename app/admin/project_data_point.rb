ActiveAdmin.register ProjectDataPoint do
  menu false

  reorderable

  permit_params :project,
                :project_id,
                :name,
                :data,
                :position

  filter :name_cont, label: 'Name'

  index do
    column :project
    column :name
    column :data

    actions
  end

  form do |f|
    inputs do
      input :name
      input :data
      input :project
    end

    actions
  end
end
