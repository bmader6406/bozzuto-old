ActiveAdmin.register Photo do
  menu parent: 'Ronin',
       label:  'Photos'

  reorderable

  permit_params :title,
                :photo_group,
                :photo_group_id,
                :property,
                :property_id,
                :image,
                :show_on_mobile,
                :position

  filter :title_cont, label: 'Title'
  filter :photo_group

  index do
    column :image
    column :title
    column :photo_group
    column :property

    actions
  end

  form do |f|
    inputs do
      input :title
      input :photo_group
      input :property
      input :image
      input :show_to_mobile
    end

    actions
  end
end
