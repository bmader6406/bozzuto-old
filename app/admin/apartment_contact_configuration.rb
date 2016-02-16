ActiveAdmin.register ApartmentContactConfiguration do
  menu parent: 'Ronin'

  permit_params :apartment_community_id,
                :upcoming_intro_text,
                :upcoming_thank_you_text

  filter :upcoming_intro_text_or_upcoming_thank_you_text_cont, label: 'Search'

  index do
    column :upcoming_intro_text,     -> (config) { config.upcoming_intro_text.html_safe }
    column :upcoming_thank_you_text, -> (config) { config.upcoming_thank_you_text.html_safe }

    actions
  end
end
