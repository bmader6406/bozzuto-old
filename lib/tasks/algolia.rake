namespace :algoliasearch do
  desc "Setup Index settings"
  task :set_index_settings => :environment do
    index = Algolia::Index.new("#{DEFAULT_ALGOLIA_OPTIONS[:index_name]}_#{Rails.env.to_s}")
    index.set_settings({
      "searchableAttributes" => %w[
        name,title
        header_title,company
        listing_text
        property_features,property_amenities
        city
        neighborhoods,areas,home_neighborhoods,area,metro
        state
        description,detail_description,neighborhood_description,overview_text
        body,bio
        unordered(leadership_groups)
        zip_code
      ],
      "attributesToRetrieve" => %w[name title],
      "ranking" => %w[words filters proximity exact attribute asc(type_ranking) typo custom],
      "customRanking" => ["asc(type_ranking)"],
      "disablePrefixOnAttributes" => %w[
        listing_text
        property_features
        property_amenities
        body
        bio
        description
        detail_description
        neighborhood_description
        overview_text
        leadership_groups
        zip_code
      ],
      "alternativesAsExact" => %w[ignorePlurals singleWordSynonym],
      "minProximity" => 2,
      "numericAttributesForFiltering": %w[type_ranking]
    })
  end
end
