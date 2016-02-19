ActiveAdmin.register MastheadSlideshow do
  menu parent: 'Ronin',
       label:  'Masthead Slideshows'

  permit_params :name,
                :page,
                :page_id

  filter :name_cont, label: 'Name'

  index do
    column :name
    column :page

    actions
  end

  form do |f|
    inputs do
      input :name
      input :page
    end

    actions
  end
end
