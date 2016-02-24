ActiveAdmin.register LandingPage do
  menu parent: 'Geography'

  permit_params :title,
                :state_id,
                :meta_title,
                :meta_description,
                :meta_keywords,
                :masthead_body,
                :masthead_image,
                :masthead_image_url,
                :promo_id,
                :local_info_feed_id,
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
            row :title
            row :state
            row :meta_title
            row :meta_description
            row :meta_keywords
            row :masthead_body
            row :masthead_image do |page|
              if page.masthead_image.present?
                image_tag page.masthead_image
              end
            end
            row :masthead_image_url
            row :promo
            row :local_info_feed
            row :secondary_title
            row :secondary_body
            row(:published) { |page| page.published? ? status_tag(:yes) : status_tag(:no) }
            row(:hide_from_list) { |page| page.hide_from_list? ? status_tag(:yes) : status_tag(:no) }
            row(:show_apartments_by_area) { |page| page.show_apartments_by_area? ? status_tag(:yes) : status_tag(:no) }
            row(:custom_sort_popular_properties) { |page| page.custom_sort_popular_properties? ? status_tag(:yes) : status_tag(:no) }
            row(:randomize_property_listings) { |page| page.randomize_property_listings? ? status_tag(:yes) : status_tag(:no) }
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
            # TODO Fill in after ApartmentCommunity is in AA.
          end
        end
      end

      tab 'Apartment Communities' do
        collection_panel_for :apartment_communities do
          table_for page.apartment_communities do
            # TODO Fill in after ApartmentCommunity is in AA.
          end
        end
      end

      tab 'Home Communities' do
        collection_panel_for :home_communities do
          table_for page.home_communities do
            # TODO Fill in after HomeCommunity is in AA.
          end
        end
      end

      tab 'Projects' do
        collection_panel_for :projects do
          table_for page.projects do
            # TODO Fill in after Project is in AA.
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
          input :state
          input :meta_title
          input :meta_description
          input :meta_keywords
          input :masthead_body, as: :redactor
          input :masthead_image, as: :image
          input :masthead_image_url
          input :promo
          input :local_info_feed
          input :secondary_title
          input :secondary_body, as: :redactor
          input :published
          input :hide_from_list
          input :show_apartments_by_area
          input :custom_sort_popular_properties
          input :randomize_property_listings
        end

        tab 'Popular Properties' do
          has_many :popular_property_orderings, heading: false, allow_destroy: true, new_record: 'Add Property' do |property|
            property.input :property
          end
        end

        tab 'Apartments' do
          input :apartment_communities
        end

        tab 'Featured Apartments' do
          input :featured_apartment_communities
        end

        tab 'Homes' do
          input :home_communities
        end

        tab 'Projects' do
          input :projects
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
