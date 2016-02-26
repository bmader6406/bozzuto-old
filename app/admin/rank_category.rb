ActiveAdmin.register RankCategory do
  menu parent: 'Ronin',
       label:  'Rank Categories'

  reorderable

  permit_params :name,
                :publication,
                :publication_id,
                :position

  filter :name_cont, label: 'Name'

  index do
    column :name
    column :publication

    actions
  end

  form do |f|
    inputs do
      input :name
      input :publication
    end

    actions
  end
end
