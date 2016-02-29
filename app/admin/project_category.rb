ActiveAdmin.register ProjectCategory do
  menu parent: 'Properties', label: 'Project Categories'

  config.sort_order = 'position_asc'

  reorderable

  permit_params :title,
                :position

  filter :title_cont, label: 'Title'

  # Work around for models who have overridden `to_param` in AA
  # See SO issue:
  # http://stackoverflow.com/questions/7684644/activerecordreadonlyrecord-when-using-activeadmin-and-friendly-id
  before_filter do
    ProjectCategory.class_eval do
      def to_param
        id.to_s
      end
    end
  end

  index as: :reorderable_table do
    column :title

    actions
  end

  show do
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for resource do
            rows :id
            rows :title, :slug
            rows :created_at, :updated_at
          end
        end
      end

      tab 'Projects' do
        collection_panel_for :projects do
          table_for resource.projects.ordered_by_title do
            column :title
            column :published
            column :street_address
            column :city
          end
        end
      end
    end
  end

  form do |f|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for resource do
            inputs do
              input :title
            end
          end
        end
      end

      tab 'Projects' do
        panel nil do
          association_table_for :projects, scope: resource.projects.ordered_by_title do
            column :title
            column :published
            column :street_address
            column :city
          end
        end
      end
    end

    actions
  end
end
