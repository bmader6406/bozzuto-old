ActiveAdmin.register Publication do
  menu parent: 'News & Press'

  permit_params :name,
                :description,
                :image,
                :published,
                :position

  filter :name_cont, label: 'Name'

  index do
    column :name

    actions
  end

  form do |f|
    inputs do
      input :name
      input :description, as: :redactor
      input :image, as: :image
      input :published
    end

    actions
  end
end
