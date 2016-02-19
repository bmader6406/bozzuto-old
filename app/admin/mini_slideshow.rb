ActiveAdmin.register MiniSlideshow do
  menu parent: 'Ronin',
       label:  'Mini Slideshows'

  permit_params :title,
                :subtitle,
                :link_url

  filter :title_cont, label: 'Title'

  index do
    column :title

    actions
  end

  form do |f|
    inputs do
      input :title
      input :subtitle
      input :link_url
    end

    actions
  end
end
