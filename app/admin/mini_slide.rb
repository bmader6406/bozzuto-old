ActiveAdmin.register MiniSlide do
  config.filters = false

  menu false

  reorderable

  permit_params :mini_slideshow_id,
                :image,
                :position

  index do
    column :image do |slide|
      if slide.image.present?
        image_tag slide.image
      end
    end
    column :mini_slideshow

    actions
  end

  form do |f|
    inputs do
      input :image, as: :image
      input :mini_slideshow
    end

    actions
  end
end
