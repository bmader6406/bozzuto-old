class MigrateToNeighborhoodPage < ActiveRecord::Migration
  def self.up
    ApartmentCommunity
    HomeCommunity
    say "Migrating Neighborhood from Property to PropertyNeighborhoodPage..."
    Community.all.each do |community|
      if community_have_neighborhood?(community)
        say "Migrating Property #{community.id} #{community.title.inspect}"
        page = community.create_neighborhood_page({
          :content => community.neighborhood_text,
          :meta_title => community.neighborhood_meta_title,
          :meta_description => community.neighborhood_meta_description,
          :meta_keywords => community.neighborhood_meta_keywords
        })
        if page.new_record?
          say "Page failed to save: #{page.errors.full_messages.to_sentence}", true
        end
      end
    end
  end

  def self.down
    ApartmentCommunity
    HomeCommunity
    say "Migrating Neighborhood from PropertyNeighborhoodPage to Property..."
    Community.all.each do |community|
      if community.neighborhood_page.present?
        say_with_time "Migrating Property #{community.id} #{community.title.inspect}"
        community.update_attributes({
          :neighborhood_text => community.neighborhood_page.content,
          :neighborhood_meta_title => community.neighborhood_page.meta_title,
          :neighborhood_meta_description => community.neighborhood_page.meta_description,
          :neighborhood_meta_keywords => community.neighborhood_page.meta_keywords
        })
      end
    end
  end
  
  private
  
  def self.community_have_neighborhood?(community)
    community.neighborhood_text? || community.neighborhood_meta_title? ||
      community.neighborhood_meta_description? || community.neighborhood_meta_keywords?
  end
end
