ActiveAdmin.register Snippet do
  config.sort_order = 'name_asc'

  track_changes

  menu parent: 'Content'

  permit_params :name,
                :body

  filter :name_cont, label: 'Name'

  index do
    column :name

    actions
  end

  sidebar :help, only: :index, priority: 0 do
    div class: 'panel_contents_text' do
      'Blocks of text that may appear multiple times throughout the site.'
    end
  end

  show do
    attributes_table do
      row :id
      row :name
      row :body do |snippet|
        raw snippet.body
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs do
      input :name
      input :body, as: :redactor
    end

    actions
  end
end
