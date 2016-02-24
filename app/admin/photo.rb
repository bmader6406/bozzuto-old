ActiveAdmin.register Photo do
  menu parent: 'Media',
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
    column :image do |photo|
      if photo.image.present?
        image_tag photo.image.url(:thumb)
      end
    end
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
      input :image, as: :image
      input :show_to_mobile
    end

    actions
  end
end
