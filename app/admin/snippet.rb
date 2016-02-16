ActiveAdmin.register Snippet do
  menu parent: 'Content'

  permit_params :name,
                :body

  filter :name_cont, label: "Name"

  index do
    column :name

    actions
  end

  form do |f|
    inputs do
      input :name
      input :body
    end

    actions
  end
end
