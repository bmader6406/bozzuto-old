ActiveAdmin.register CareersEntry do
  config.sort_order = 'position_asc'

  menu parent: 'Content', label: 'Career Entries'

  reorderable

  permit_params :name,
                :company,
                :job_title,
                :job_description,
                :youtube_url,
                :main_photo,
                :headshot

  filter :name_cont,      label: 'Name'
  filter :job_title_cont, label: 'Job Title'

  index as: :reorderable_table do
    column :name
    column :job_title

    actions
  end

  show do
    attributes_table do
      row :name
      row :company
      row :job_title
      row :job_description
      row :youtube_url do |entry|
        if entry.youtube_url.present?
          link_to entry.youtube_url, entry.youtube_url, target: :blank
        end
      end
      row :main_photo do |entry|
        if entry.main_photo.present?
          image_tag entry.main_photo
        end
      end
      row :headshot do |entry|
        if entry.headshot.present?
          image_tag entry.headshot
        end
      end
    end
  end

  form do |f|
    inputs do
      input :name
      input :company
      input :job_title
      input :job_description
      input :youtube_url
      input :main_photo
      input :headshot

      actions
    end
  end
end
