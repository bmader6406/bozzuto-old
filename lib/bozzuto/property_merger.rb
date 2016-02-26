module Bozzuto
  class PropertyMerger < Struct.new(:property)
    extend  ActiveModel::Naming
    include ActiveModel::Conversion

    attr_accessor :target_property_id

    def process(parameters)
      tap do
        self.target_property_id = parameters[self.class.model_name.singular_route_key].try(:fetch, :target_property_id, nil)
      end
    end

    def target_property
      @target_property ||= target_scope.find_by(id: target_property_id)
    end

    def target_merge_properties
      @target_merge_properties = target_scope.group_by(&:external_cms_type).map do |(type, communities)|
        [communities.first.external_cms_name, communities.sort_by(&:title).map { |c| [c.title, c.id] }]
      end
    end

    def feed_name
      @feed_name ||= target_property.try(:external_cms_name)
    end

    def to_s
      verb = target_property.persisted? ? 'Merging' : 'Merged'

      [verb, property, 'with', target_property].join(' ')
    end

    def merge!
      property.merge(target_property)
    end

    private

    def target_scope
      @target_scope ||= ApartmentCommunity.where('external_cms_type IS NOT NULL')
    end
  end
end
