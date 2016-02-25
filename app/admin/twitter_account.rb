ActiveAdmin.register TwitterAccount do
  menu parent: 'Ronin'

  permit_params :username

  filter :username_cont, label: 'Username'

  index do
    column :username

    actions
  end

  show do
    attributes_table do
      row :id
      row :username
      row :next_update_at
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    semantic_errors

    inputs do
      input :username
    end

    actions
  end
end
