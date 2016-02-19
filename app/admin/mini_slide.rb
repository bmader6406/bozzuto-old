ActiveAdmin.register MiniSlide do
  menu parent: 'Ronin',
       label:  'Mini Slides'

  config.filters = false

  permit_params :mini_slideshow,
                :mini_slideshow_id,
                :image,
                :position

  index do
    column :image
    column :mini_slideshow

    actions
  end

  form do |f|
    inputs do
      input :image
      input :mini_slideshow
    end

    actions
  end
end
