ActiveAdmin.register LandingPage do
  menu parent: 'Geography', label: 'Landing Pages'

  permit_params :title,
                :state_id,
                :meta_title,
                :meta_description,
                :meta_keywords,
                :masthead_body,
                :masthead_image,
                :masthead_image_url,
                :promo_id,
                :secondary_title,
                :secondary_body,
                :published,
                :hide_from_list,
                :show_apartments_by_area,
                :custom_sort_popular_properties,
                :randomize_property_listings,
                apartment_community_ids: [],
                featured_apartment_community_ids: [],
                home_community_ids: [],
                project_ids: [],
                popular_property_orderings_attributes: [
                  :id,
                  :property_id,
                  :property_type,
                  :_destroy
                ]

  filter :title_or_meta_title_or_meta_description_or_meta_keywords_cont, label: 'Search'
  filter :state
  filter :published

  index do
    column :title
    column :state
    column :published

    actions
  end

  show do |page|
    tabs do
      tab 'Details' do
        panel nil do
          attributes_table_for page do
            row :id
            row :title
            row :slug
            row :state
            row :meta_title
            row :meta_description
            row :meta_keywords
            row :masthead_body do |page|
              raw page.masthead_body
            end
            row :masthead_image do |page|
              if page.masthead_image.present?
                image_tag page.masthead_image
              end
            end
            row :masthead_image_url
            row :promo
            row :secondary_title
            row :secondary_body do |page|
              raw page.secondary_body
            end
            row :published do |page|
              status_tag page.published
            end
            row :hide_from_list do |page|
              status_tag page.hide_from_list
            end
            row :show_apartments_by_area do |page|
              status_tag page.show_apartments_by_area
            end
            row :custom_sort_popular_properties do |page|
              status_tag page.custom_sort_popular_properties
            end
            row :randomize_property_listings do |page|
              status_tag page.randomize_property_listings
            end
            row :created_at
            row :updated_at
          end
        end
      end

      tab 'Popular Properties' do
        collection_panel_for :popular_property_orderings do
          reorderable_table_for page.popular_property_orderings do
            column :property
          end
        end
      end

      tab 'Featured Apartment Communities' do
        collection_panel_for :featured_apartment_communities do
          table_for page.featured_apartment_communities do
            column :title
            column :street_address
            column :city
            column :published
            column :featured
          end
        end
      end

      tab 'Apartment Communities' do
        collection_panel_for :apartment_communities do
          table_for page.apartment_communities do
            column :title
            column :street_address
            column :city
            column :published
            column :featured
          end
        end
      end

      tab 'Home Communities' do
        collection_panel_for :home_communities do
          table_for page.home_communities do
            column :title
            column :street_address
            column :city
            column :published
          end
        end
      end

      tab 'Projects' do
        collection_panel_for :projects do
          table_for page.projects do
            column :title
            column :street_address
            column :city
            column :published
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
          input :state,                           as: :chosen
          input :meta_title
          input :meta_description
          input :meta_keywords
          input :masthead_body,                   as: :redactor
          input :masthead_image,                  as: :image
          input :masthead_image_url
          input :promo,                           as: :chosen
          input :secondary_title
          input :secondary_body,                  as: :redactor
          input :published
          input :hide_from_list
          input :show_apartments_by_area
          input :custom_sort_popular_properties
          input :randomize_property_listings
        end

        tab 'Popular Properties' do
          has_many :popular_property_orderings, heading: false, allow_destroy: true, new_record: 'Add Property' do |property|
            property.input :property, as: :polymorphic_select, grouped_options: community_select_options, input_html: { class: 'chosen-input' }
          end
        end

        tab 'Apartments' do
          input :apartment_communities, as: :chosen
        end

        tab 'Featured Apartments' do
          input :featured_apartment_communities, as: :chosen
        end

        tab 'Homes' do
          input :home_communities, as: :chosen
        end

        tab 'Projects' do
          input :projects, as: :chosen
        end
      end

      actions
    end
  end

  controller do
    def find_resource
      LandingPage.friendly.find(params[:id])
    end
  end
end
