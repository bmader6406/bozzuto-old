ActiveAdmin.register Feed do
  menu parent: 'System', label: 'Feeds'

  permit_params :name, :url

  filter :name_or_url_cont, label: 'Search'

  # TODO ADD IN ASSOCIATIONS & SHOW PAGE
  index do
    column :name
    column :url
    column :refreshed_at do |feed|
      if feed.refreshed_at.present?
        feed.refreshed_at.to_s(:extensive)
      end
    end

    actions
  end

  form do |f|
    inputs do
      input :name
      input :url

      actions
    end
  end
end
