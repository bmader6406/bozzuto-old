ActiveAdmin.register PropertySlide do
  menu false

  track_changes

  config.filters    = false
  config.sort_order = "position_asc"

  reorderable

  permit_params :image,
                :caption,
                :link_url,
                :video_url,
                :property_slideshow_id

  index do
    column :property_slideshow
    column :image do |slide|
      if slide.image.present?
        image_tag slide.image.url(:thumb)
      end
    end

    actions
  end

  show do |slide|
    attributes_table do
      row :id
      row :property_slideshow
      row :image do |slide|
        if slide.image.present?
          image_tag slide.image
        end
      end
      row :caption
      row :link_url
      row :video_url
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs do
      input :property_slideshow, as: :chosen
      input :image,              as: :image
      input :caption
      input :link_url
      input :video_url
    end

    actions
  end
end
