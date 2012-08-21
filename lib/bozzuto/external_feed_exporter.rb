module Bozzuto
  class ExternalFeedExporter < ExternalFeedLoader
    include ActionController::UrlWriter
    include PropertiesHelper

    default_url_options[:host] = ActionMailer::Base.default_url_options[:host] || 'bozzuto.com'

    def data
      { :properties => community_data }
    end

    private

    def community_data
      ApartmentCommunity.all.collect do |community|
        {
          :id                  => community.id,
          :community_name      => community.title,
          :community_address_1 => community.street_address,
          :city                => community.city.name,
          :state               => community.city.state.code,
          :postal_code         => community.zip_code,
          :county              => community.county.try(:name),
          :lead_2_lease_email  => community.lead_2_lease_email,
          :phone_number        => community.phone_number,
          :features            => community_features(community),
          :photo_set           => community_photo_set(community),
          :video_url           => community.video_url,
          :neighborhood_text   => community.neighborhood_page.try(:content),
          :office_hours        => community.office_hours,
          :overview_text       => community.overview_text,
          :overview_bullet_1   => community.overview_bullet_1,
          :overview_bullet_2   => community.overview_bullet_2,
          :overview_bullet_3   => community.overview_bullet_3,
          :facebook_url        => community.facebook_url,
          :twitter_handle      => community.twitter_handle,
          :pinterest_url       => community.pinterest_url,
          :website_url         => community.website_url,
          :latitude            => community.latitude,
          :longitude           => community.longitude,
          :floorplans          => community_floor_plans(community),
          :promo               => community_promo(community),
          :featured_buttons    => community_featured_buttons(community),
          :directions_url      => directions_url(community.address),
          :local_info_feed     => community.local_info_feed.try(:url),
          :nearby_communities  => nearby_communities(community),
          :bozzuto_url         => apartment_community_url(community)
        }
      end
    end

    def community_features(community)
      features_page = community.features_page

      [].tap do |features|
        if features_page
          1.upto(3) do |n|
            if features_page.send("title_#{n}").present?
              features << {
                :title => features_page.send("title_#{n}"),
                :text  => features_page.send("text_#{n}")
              }
            end
          end
        end
      end
    end

    def community_photo_set(community)
      photo_set = community.photo_set

      {}.tap do |attrs|
        if photo_set
          attrs[:title] = photo_set.title
          attrs[:flickr_set_number] = photo_set.flickr_set_number
        end
      end
    end

    def community_floor_plans(community)
      community.floor_plans.collect do |floor_plan|
        {
          :id                 => floor_plan.id,
          :name               => floor_plan.name,
          :availability_url   => floor_plan.availability_url,
          :min_square_feet    => floor_plan.min_square_feet,
          :max_square_feet    => floor_plan.max_square_feet,
          :min_market_rent    => floor_plan.min_market_rent,
          :max_market_rent    => floor_plan.max_market_rent,
          :min_effective_rent => floor_plan.min_effective_rent,
          :max_effective_rent => floor_plan.max_effective_rent,
          :units              => floor_plan_units(floor_plan)
        }
      end
    end

    def floor_plan_units(floor_plan)
      floor_plan.units.collect do |unit|
        {
          :id               => unit.id,
          :availability_url => unit.availability_url
        }
      end
    end

    def community_promo(community)
      promo = community.promo

      {}.tap do |attrs|
        if promo && promo.active?
          attrs[:title] = promo.title
          attrs[:subtitle] = promo.subtitle
          attrs[:link_url] = promo.link_url
          attrs[:expiration_date] = promo.expiration_date
        end
      end
    end

    def community_featured_buttons(community)
      community.property_features.collect do |feature|
        { :name => feature.name }
      end
    end

    def nearby_communities(community)
      community.nearby_communities.collect do |nearby_community|
        {
          :id    => nearby_community.id,
          :title => nearby_community.title
        }
      end
    end
  end
end
