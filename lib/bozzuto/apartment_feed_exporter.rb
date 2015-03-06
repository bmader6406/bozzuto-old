module Bozzuto
  class ApartmentFeedExporter
    include Rails.application.routes.url_helpers
    include PropertiesHelper

    default_url_options[:host] = ActionMailer::Base.default_url_options[:host] || 'bozzuto.com'

    def data
      { :properties => community_data }
    end

    def to_xml
      builder = Builder::XmlMarkup.new(:indent => 2)
      builder.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
      builder.PhysicalProperty do |node|
        data[:properties].each do |property|
          property_node(node, property)
        end
      end
    end

    private

    def community_data
      ApartmentCommunity.included_in_export.collect do |community|
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
          :slideshow_slides    => community_slideshow(community),
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
          :bozzuto_url         => apartment_community_url(community),
          :listing_image       => url_for_image(community.listing_image.url)
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

    def community_slideshow(community)
      slideshow = community.slideshow

      [].tap do |slides|
        if slideshow
          slideshow.slides.each do |slide|
            slides << {
              :image_url => slide.image.url(:slide)
            }
          end
        end
      end
    end

    def community_floor_plans(community)
      community.floor_plans.collect do |floor_plan|
        {
          :id               => floor_plan.id,
          :name             => floor_plan.name,
          :availability_url => floor_plan.availability_url,
          :available_units  => floor_plan.available_units,
          :image_url        => (url_for_image(floor_plan.actual_image) if floor_plan.actual_image.present?),
          :bedrooms         => floor_plan.bedrooms,
          :bathrooms        => floor_plan.bathrooms,
          :min_square_feet  => floor_plan.min_square_feet,
          :max_square_feet  => floor_plan.max_square_feet,
          :min_rent         => floor_plan.available_units.zero? ? 0 : floor_plan.min_rent,
          :max_rent         => floor_plan.available_units.zero? ? 0 : floor_plan.max_rent,
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
      community.nearby_communities.included_in_export.map do |nearby_community|
        {
          :id    => nearby_community.id,
          :title => nearby_community.title
        }
      end
    end

    def property_node(parent_node, property)
      parent_node.tag!('Property') do |node|
        property_id_node(node, property)
        information_node(node, property)

        property[:features].each do |feature|
          feature_node(node, feature)
        end

        property[:featured_buttons].each do |featured_button|
          featured_button_node(node, featured_button)
        end

        slideshow_node(node, property[:slideshow_slides])

        property[:nearby_communities].each do |nearby_community|
          nearby_community_node(node, nearby_community)
        end

        property[:floorplans].each do |floorplan|
          floorplan_node(node, floorplan)
        end

        promotion_node(node, property[:promo])
      end
    end

    def property_id_node(parent_node, property)
      parent_node.tag!('PropertyID') do |node|
        identification_node(node, property)
        address_node(node, property)
        phone_node(node, property)
      end
    end

    def identification_node(parent_node, property)
      parent_node.tag!('Identification') do |node|
        node.tag! 'PrimaryID', property[:id]
        node.tag! 'MarketingName', property[:community_name]
        node.tag! 'WebSite', property[:website_url]
        node.tag! 'BozzutoURL', property[:bozzuto_url]
        node.tag! 'Latitude', property[:latitude]
        node.tag! 'Longitude', property[:longitude]
      end
    end

    def address_node(parent_node, property)
      parent_node.tag!('Address') do |node|
        node.tag! 'Address1', property[:community_address_1]
        node.tag! 'City', property[:city]
        node.tag! 'State', property[:state]
        node.tag! 'PostalCode', property[:postal_code]
        node.tag! 'CountyName', property[:county]
        node.tag! 'Lead2LeaseEmail', property[:lead_2_lease_email]
      end
    end

    def phone_node(parent_node, property)
      parent_node.tag!('Phone', 'Type' => 'office') do |node|
        node.tag! 'PhoneNumber', property[:phone_number]
      end
    end

    def information_node(parent_node, property)
      parent_node.tag!('Information') do |node|
        if property[:office_hours]
          property[:office_hours].each do |office_hour|
            office_hour_node(node, office_hour)
          end
        end
        node.tag! 'OverviewText', property[:overview_text]
        node.tag! 'OverviewTextStripped', strip_tags_and_whitespace(property[:overview_text])
        node.tag! 'OverviewBullet1', property[:overview_bullet_1]
        node.tag! 'OverviewBullet2', property[:overview_bullet_2]
        node.tag! 'OverviewBullet3', property[:overview_bullet_3]
        node.tag! 'NeighborhoodText', property[:neighborhood_text]
        node.tag! 'DirectionsURL', property[:directions_url]
        node.tag! 'LocalInfoRSSURL', property[:local_info_feed]
        node.tag! 'ListingImageURL', property[:listing_image]
        node.tag! 'VideoURL', property[:video_url]
        node.tag! 'FacebookURL', property[:facebook_url]
        node.tag! 'TwitterHandle', property[:twitter_handle]
        node.tag! 'PinterestURL', property[:pinterest_url]
      end
    end

    def office_hour_node(parent_node, office_hour)
      parent_node.tag!('OfficeHour') do |node|
        node.tag! 'OpenTime', "#{office_hour.opens_at} #{office_hour.opens_at_period}"
        node.tag! 'CloseTime', "#{office_hour.closes_at} #{office_hour.closes_at_period}"
        node.tag! 'Day', office_hour.day_name
      end
    end

    def feature_node(parent_node, feature)
      parent_node.tag!('Feature') do |node|
        node.tag! 'Title', feature[:title]
        node.tag! 'Description', feature[:text]
      end
    end

    def featured_button_node(parent_node, featured_button)
      parent_node.tag!('FeaturedButton') do |node|
        node.tag! 'Name', featured_button[:name]
      end
    end

    def slideshow_node(parent_node, slideshow_slides)
      parent_node.tag!('Slideshow') do |node|
        slideshow_slides.each do |slide|
          node.tag! 'SlideshowImageURL', "http://#{default_url_options[:host]}#{slide[:image_url]}"
        end
      end
    end

    def nearby_community_node(parent_node, nearby_community)
      parent_node.tag!('NearbyCommunity', 'Id' => nearby_community[:id]) do |node|
        node.tag! 'Name', nearby_community[:title]
      end
    end

    def floorplan_node(parent_node, floorplan)
      parent_node.tag!('Floorplan', 'Id' => floorplan[:id]) do |node|
        node.tag! 'Name', floorplan[:name]
        node.tag! 'FloorplanAvailabilityURL', floorplan[:availability_url]
        node.tag! 'DisplayedUnitsAvailable', floorplan[:available_units]
        node.tag! 'ImageURL', floorplan[:image_url] if floorplan[:image_url]
        node.tag! 'Bedrooms', floorplan[:bedrooms]
        node.tag! 'Bathrooms', floorplan[:bathrooms]
        node.tag! 'SquareFeet',
          'Min' => floorplan[:min_square_feet],
          'Max' => floorplan[:max_square_feet]
        node.tag! 'MarketRent',
          'Min' => format_float_for_xml(floorplan[:min_rent]),
          'Max' => format_float_for_xml(floorplan[:max_rent])
        node.tag! 'EffectiveRent',
          'Min' => format_float_for_xml(floorplan[:min_rent]),
          'Max' => format_float_for_xml(floorplan[:max_rent])
      end
    end

    def promotion_node(parent_node, promo)
      parent_node.tag!('Promotion') do |node|
        node.tag! 'Title', promo[:title]
        node.tag! 'Subtitle', promo[:subtitle]
        node.tag! 'LinkURL', promo[:link_url]
        node.tag! 'ExpirationDate',
          'Month' => promo[:expiration_date].try(:strftime, '%m'),
          'Day'   => promo[:expiration_date].try(:strftime, '%d'),
          'Year'  => promo[:expiration_date].try(:strftime, '%Y')
      end
    end

    def format_float_for_xml(value)
      if value.present?
        '%g' % value.to_f
      else
        ''
      end
    end

    def url_for_image(path, options={})
      options = default_url_options.merge(options)

      ''.tap do |url|
        unless path =~ %r{^https?://}
          url << (options.delete(:protocol) || 'http')
          url << '://' unless url.match("://")
          url << options.delete(:host)
          url << ":#{options.delete(:port)}" if options.key?(:port)
        end

        url << path
      end
    end

    def sanitizer
      @sanitizer ||= HTML::FullSanitizer.new
    end

    def strip_tags_and_whitespace(html)
      sanitizer.sanitize(String(html)).gsub(/\s+/, ' ').strip
    end
  end
end
