ActiveAdmin.register Publication do
  menu parent: 'News & Press'

  config.sort_order = "position_asc"

  reorderable

  permit_params :name,
                :description,
                :image,
                :published

  filter :name_cont, label: 'Name'

  index as: :reorderable_table do
    column :name

    actions
  end

  show do |publication|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for publication do
            row :id
            row :name
            row :published do
              status_tag publication.published
            end
            row :image do
              if publication.image.present?
                image_tag publication.image.url
              end
            end
            row :description do
              raw publication.description
            end
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Rank Categories' do
        collection_panel_for :rank_categories do
          reorderable_table_for publication.rank_categories do
            column :name do |rank_category|
              link_to rank_category.name, [:admin, rank_category]
            end
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
          input :published
          input :image,       as: :image
          input :description, as: :redactor
        end

        tab 'Rank Categories' do
          association_table_for :rank_categories do
            column :name
          end
        end
      end
    end

    actions
  end
end
