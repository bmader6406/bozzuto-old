ActiveAdmin.register Testimonial do
  menu parent: 'Content'

  track_changes

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
    column :quote do |t|
      t.excerpt
    end

    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :title
      row :quote do |t|
        raw t.quote
      end
      row :section
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    inputs do
      input :name
      input :title
      input :quote,   as: :redactor
      input :section, as: :chosen,   collection: Section.ordered_by_title
    end

    actions
  end
end
