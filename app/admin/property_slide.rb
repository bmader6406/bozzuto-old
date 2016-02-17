ActiveAdmin.register PropertySlide do
  menu parent: 'Ronin',
       label:  'Property Slides'

  config.filters = false

  permit_params :image,
                :caption,
                :link_url,
                :video_url,
                :position,
                :property_slideshow,
                :property_slideshow_id

  index do
    column :property_slideshow
    column :image

    actions
  end

  form do |f|
    inputs do
      input :image
      input :caption
      input :link_url
      input :video_url
      input :property_slideshow
    end

    actions
  end
end
