ActiveAdmin.register ContactTopic do
  config.sort_order = 'position_asc'

  menu parent: 'Content', label: 'Contact Form Topics'
  
  filter :topic_cont, label: 'Topic'

  reorderable

  index as: :reorderable_table do
    column :topic
    
    actions
  end

  form do |f|
    inputs do
      input :topic
      input :body,        as: :redactor
      input :recipients
      input :section,     as: :chosen

      actions
    end
  end
end
