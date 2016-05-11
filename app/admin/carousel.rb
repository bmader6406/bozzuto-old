ActiveAdmin.register Carousel do
  menu parent: 'Media'

  track_changes

  permit_params :name,
                :content_type,
                :content_id,
                panels_attributes: [
                  :id,
                  :image,
                  :link_url,
                  :heading,
                  :caption,
                  :featured,
                  :carousel_id,
                  :_destroy
                ]

  filter :name_cont, label: 'Name'

  index do
    column :name

    actions
  end

  show do |carousel|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for carousel do
            row :id
            row :name
            row :content
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Panels' do
        collection_panel_for :panels do
          reorderable_table_for carousel.panels do
            column :image do |panel|
              if panel.image.present?
                image_tag panel.image
              end
            end
            column :link_url
            column :heading
            column :caption
            column :featured
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
          input :content, as: :polymorphic_select, grouped_options: content_options, input_html: { class: 'chosen-input' }
        end

        tab 'Panels' do
          has_many :panels, heading: false, allow_destroy: true do |panel|
            panel.input :image,     as: :image
            panel.input :link_url
            panel.input :heading
            panel.input :caption
            panel.input :featured
          end
        end
      end

      actions
    end
  end

  controller do
    def content_options
      @content_options ||= {
        HomePage => HomePage.all,
        Page     => Page.all
      }
    end
    helper_method :content_options
  end
end
