ActiveAdmin.register RankCategory do
  menu false

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

  show do |rank_category|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for rank_category do
            row :id
            row :name
            row :publication
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Ranks' do
        collection_panel_for :ranks do
          table_for rank_category.ranks do
            column :year
            column :rank_number
          end
        end
      end
    end
  end

  form do |f|
    inputs do
      tabs do
        tab 'Details' do
          input :name
          input :publication
        end

        tab 'Ranks' do
          association_table_for :ranks do
            column :year
            column :rank_number
          end
        end
      end
    end

    actions
  end
end
