ActiveAdmin.register Snippet do
  menu parent: 'Content'

  config.sort_order = 'name_asc'

  permit_params :name,
                :body

  filter :name_cont, label: 'Name'

  index do
    column :name

    actions
  end

  sidebar :help, only: :index, priority: 0 do
    'Blocks of text that may appear multiple times throughout the site.'
  end

  show do
    attributes_table do
      rows :id
      rows :name
      row  :body do |s|
        raw s.body
      end
      rows :created_at, :updated_at
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
