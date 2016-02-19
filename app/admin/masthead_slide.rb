ActiveAdmin.register MastheadSlide do
  menu parent: 'Ronin',
       label:  'Masthead Slides'

  config.filters = false

  permit_params :image

  index do
    column :image
    column :image_link

    actions
  end

  form do |f|
    inputs do
      input :body
      input :slide_type, as: :select, collection: MastheadSlide::SLIDE_TYPE

      input :image
      input :image_link

      input :sidebar_text

      input :mini_slideshow

      input :quote
      input :quote_attribution
      input :quote_job_title
      input :quote_company

      input :masthead_slideshow
    end

    actions
  end
end
