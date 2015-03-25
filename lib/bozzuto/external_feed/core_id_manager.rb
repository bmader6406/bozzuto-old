module Bozzuto::ExternalFeed
  class CoreIdManager
    attr_reader :community

    def self.assign_core_ids!
      new.assign_core_ids!
    end

    def self.clear_core_ids!
      new.clear_core_ids!
    end

    def initialize(community = nil)
      @community = community
    end

    def assign_core_ids!
      ApartmentCommunity.find_each do |community|
        if community.core_id.nil?
          community.update_attributes :core_id => core_id_for(community)
        end
      end
    end

    def clear_core_ids!
      ApartmentCommunity.update_all(:core_id => nil)
    end

    def assign_id
      return if community.core_id.present?

      core_id = if matching_community.try(:core_id).present?
        matching_community.core_id
      else
        community.id
      end

      community.update_attributes(:core_id => core_id)
    end

    private

    def core_id_for(community)
      core_id_map.fetch(community.title)
    end

    def core_id_map
      @core_id_map ||= ApartmentCommunity.all.reduce(Hash.new) do |core_id_map, community|
        if community.core_id.present?
          core_id_map.merge(community.title => community.core_id)
        elsif core_id_map[community.title].nil? || (community.included_in_export? && community.published?)
          core_id_map.merge(community.title => community.id)
        else
          core_id_map
        end
      end
    end

    def matching_community
      ApartmentCommunity.where(:title => community.title).partition(&:included_in_export?).flatten.first
    end
  end
end
