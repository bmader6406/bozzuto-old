ActiveAdmin.register PropertySlide do
  config.filters = false

  reorderable

  menu false

  permit_params :image,
                :caption,
                :link_url,
                :video_url,
                :position,
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
      row :property_slideshow
      row :image do |slide|
        if slide.image.present?
          image_tag slide.image
        end
      end
      row :caption
      row :link_url
      row :video_url
    end
  end

  form do |f|
    inputs do
      input :image, as: :image
      input :caption
      input :link_url
      input :video_url
      input :property_slideshow
    end

    actions
  end
end
