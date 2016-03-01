ActiveAdmin.register Rank do
  menu false

  config.filters    = false
  config.sort_order = 'year_desc'

  permit_params :rank_category,
                :rank_category_id,
                :year,
                :rank_number,
                :description

  index do
    column :year
    column :rank_category
    column :rank_number
    column :description

    actions
  end

  show do
    attributes_table do
      row :id
      row :rank_category
      row :year
      row :rank_number
      row :description
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs do
      input :rank_category, as: :chosen
      input :year
      input :rank_number
      input :description
    end

    actions
  end
end
