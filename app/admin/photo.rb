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
                :show_on_mobile

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

  show do |photo|
    attributes_table do
      row :id
      row :title
      row :photo_group
      row :property
      row :show_to_mobile do
        status_tag photo.show_to_mobile
      end
      row :image do
        if photo.image.present?
          image_tag photo.image.url
        end
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs do
      input :title
      input :photo_group,    as: :chosen
      input :property,       as: :chosen
      input :show_to_mobile
      input :image,          as: :image
    end

    actions
  end
end
