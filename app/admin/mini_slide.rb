ActiveAdmin.register MiniSlide do
  menu false

  config.filters = false

  reorderable

  permit_params :mini_slideshow_id,
                :image

  index do
    column :mini_slideshow
    column :image do |slide|
      if slide.image.present?
        image_tag slide.image
      end
    end

    actions
  end

  show do |slide|
    attributes_table do
      row :id
      row :mini_slideshow
      row :image do
        if slide.image.present?
          image_tag slide.image.url
        end
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs do
      input :mini_slideshow, as: :chosen
      input :image,          as: :image
    end

    actions
  end
end
