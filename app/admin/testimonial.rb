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
    column :quote do |t|
      truncate(strip_tags(t.quote), length: 100)
    end

    actions
  end

  show do
    attributes_table do
      rows :id
      rows :name
      rows :title
      row  :quote do |t|
        raw t.quote
      end
      rows :section
      rows :created_at, :updated_at
    end
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
