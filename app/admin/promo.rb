ActiveAdmin.register Promo do
  menu parent: 'Content'

  permit_params :title

  filter :title_cont, label: 'Title'

  index do
    column :title
    column :expired?
    column :expiration_date

    actions
  end

  show do
    attributes_table do
      rows :id
      rows :title, :subtitle, :link_url
      rows :has_expiration_date, :expiration_date
      rows :created_at, :updated_at
    end
  end

  form do |f|
    inputs do
      input :title
      input :subtitle
      input :link_url
      input :has_expiration_date
      input :expiration_date
    end

    actions
  end
end
