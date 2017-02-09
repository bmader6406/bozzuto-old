namespace :algoliasearch do
  desc "Setup Index settings"
  task :set_index_settings => :environment do
    index = Algolia::Index.new("#{DEFAULT_ALGOLIA_OPTIONS[:index_name]}_#{Rails.env.to_s}")
    index.set_settings({
      "searchableAttributes" => %w[
        name,title
        header_title,company
        city
        state
        unordered(listing_text)
        property_features,property_amenities
        description,detail_description,neighborhood_description,overview_text
        body,bio
        unordered(leadership_groups)
        zip_code
      ],
      "attributesToRetrieve" => %w[name title],
      "ranking" => %w[words exact attribute custom proximity typo],
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
      "alternativesAsExact" => %w[ignorePlurals singleWordSynonym multiWordsSynonym],
      "minProximity" => 2,
      "numericAttributesForFiltering": %w[type_ranking]
    })
  end
end
