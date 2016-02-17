ActiveAdmin.register Rank do
  menu parent: 'Ronin'

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
      rows :id
      rows :rank_category
      rows :year, :rank_number, :description
      rows :created_at, :updated_at
    end
  end

  form do |f|
    inputs do
      input :rank_category
      input :year
      input :rank_number
      input :description
    end

    actions
  end
end
