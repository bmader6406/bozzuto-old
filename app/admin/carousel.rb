ActiveAdmin.register Carousel do
  menu parent: 'Ronin'

  permit_params :name,
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
    panel 'Panels' do
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

  form do |f|
    inputs do
      tabs do
        tab 'Details' do
          input :name
        end

        tab 'Panels' do
          has_many :panels, heading: false, allow_destroy: true do |panel|
            panel.input :image
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
end
