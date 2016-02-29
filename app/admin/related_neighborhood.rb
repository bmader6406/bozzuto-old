ActiveAdmin.register RelatedNeighborhood do
  config.filters = false

  menu false

  permit_params :neighborhood,
                :neighborhood_id,
                :nearby_neighborhood,
                :nearby_neighborhood_id

  index do
    column :neighborhood
    column :nearby_neighborhood

    actions
  end

  form do |f|
    inputs do
      input :neighborhood
      input :nearby_neighborhood
    end

    actions
  end
end
