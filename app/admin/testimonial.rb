ActiveAdmin.register Testimonial do
  menu parent: 'Content'

  permit_params :section,
                :section_id,
                :name,
                :title,
                :quote

  filter :name_cont,  label: "Name"
  filter :title_cont, label: "Title"

  index do
    column :name
    column :title

    actions
  end

  form do |f|
    inputs do
      input :name
      input :title
      input :quote
      input :section
    end

    actions
  end
end
