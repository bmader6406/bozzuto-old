ActiveAdmin.register Project do
  menu parent: 'Properties'

  reorderable

  permit_params :title,
                :short_title,
                :short_description,
                :page_header,
                :meta_title,
                :meta_description,
                :meta_keywords,
                :section,
                :section_id,
                :street_address,
                :city,
                :county,
                :zip_code,
                :latitude,
                :longitude,
                :website_url,
                :website_url_text,
                :video_url,
                :brochure_link_text,
                :brochure_type,
                :brochure_url,
                :brochure,
                :listing_image,
                :listing_title,
                :listing_text,
                :overview_text,
                :published,
                :featured_mobile,
                :position,
                project_categories_ids: []

  # Work around for models who have overridden `to_param` in AA
  # See SO issue:
  # http://stackoverflow.com/questions/7684644/activerecordreadonlyrecord-when-using-activeadmin-and-friendly-id
  before_filter do
    Property.class_eval do
      def to_param
        id.to_s
      end
    end
  end

  controller do
    def scoped_collection
      super.includes(:city => [:state], :section => [])
    end
  end

  filter :title_cont,          label: 'Title'
  filter :street_address_cont, label: 'Street Address'
  filter :city

  index do
    column :title
    column :published
    column :street_address
    column :city
    column :section

    actions
  end

  show do
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for resource do
            rows :id
            rows :title
            rows :short_title
            rows :short_description
            rows :page_header
            rows :has_completion_date
            rows :section
            rows :website_url
            rows :website_url_text
            rows :video_url
            rows :listing_image do |project|
              if project.listing_image.present?
                image_tag project.listing_image
              end
            end
            rows :listing_title
            rows :listing_text
            rows :overview_text
            rows :published
            rows :featured_mobile
            row  :created_at
            row  :updated_at
          end
        end
      end

      tab 'Location' do
        panel nil do
          attributes_table_for resource do
            rows :street_address
            rows :city
            rows :county
            rows :zip_code
            rows :latitude
            rows :longitude
          end
        end
      end

      tab 'Brochure' do
        panel nil do
          attributes_table_for resource do
            rows :brochure_link_text
            rows :brochure_type
            rows :brochure_url
            rows :brochure
          end
        end
      end

      tab 'Seo Metadata' do
        panel nil do
          attributes_table_for resource do
            rows :meta_title
            rows :meta_description
            rows :meta_keywords
          end
        end
      end

      tab 'Slideshow' do
        collection_panel_for :slideshow do
          table_for resource.slideshow do
            column :name do |s|
              link_to s.name, [:new_admin, s]
            end
          end
        end
      end

      tab 'Data Points' do
        collection_panel_for :data_points do
          reorderable_table_for resource.data_points do
            column :position
            column :name do |d|
              link_to d.name, [:new_admin, d]
            end
            column :data
          end
        end
      end

      tab 'Updates' do
        collection_panel_for :updates do
          table_for resource.updates do
            column :update do |d|
              link_to d, [:new_admin, d]
            end
            column :published_at
            column :published
          end
        end
      end

      tab 'Categories' do
        collection_panel_for :project_categories do
          table_for resource.project_categories do
            column :title
          end
        end
      end
    end
  end

  form do |f|
    inputs do
      tabs do
        tab 'Details' do
          input :title
          input :short_title
          input :short_description
          input :page_header
          input :has_completion_date
          input :section
          input :website_url
          input :website_url_text
          input :video_url
          input :listing_image, as: :image
          input :listing_title
          input :listing_text, as: :redactor
          input :overview_text, as: :redactor
          input :published
          input :featured_mobile
        end

        tab 'Location' do
          input :street_address
          input :city
          input :county
          input :zip_code
          input :latitude
          input :longitude
        end

        tab 'Brochure' do
          input :brochure_link_text
          input :brochure_type
          input :brochure_url
          input :brochure
        end

        tab 'Seo Metadata' do
          input :meta_title
          input :meta_description
          input :meta_keywords
        end

        tab 'Slideshow' do
          panel nil do
            association_table_for :slideshow do
              column :name
            end
          end
        end

        tab 'Data Points' do
          panel nil do
            association_table_for :data_points, scope: resource.data_points.position_asc do
              column :position
              column :name
            end
          end
        end

        tab 'Updates' do
          panel nil do
            association_table_for :updates, scope: resource.updates do
              column :update do |u|
                u.to_s
              end
              column :published_at
              column :published
            end
          end
        end

        tab 'Categories' do
          input :project_categories
        end
      end
    end

    actions
  end
end
