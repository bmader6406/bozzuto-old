ActiveAdmin.register Promo do
  menu parent: 'Components'

  permit_params :title,
                :subtitle,
                :link_url,
                :has_expiration_date,
                :expiration_date

  filter :title_cont, label: 'Title'

  index do
    column :title
    column :expired? do |promo|
      status_tag promo.expired?
    end
    column :expiration_date

    actions
  end

  show do |promo|
    attributes_table do
      row :id
      row :title
      row :subtitle
      row :link_url
      row :has_expiration_date do
        status_tag promo.has_expiration_date
      end
      row :expiration_date
      row :created_at
      row :updated_at
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
