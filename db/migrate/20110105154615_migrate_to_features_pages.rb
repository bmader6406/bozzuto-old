class MigrateToFeaturesPages < ActiveRecord::Migration
  def self.up
    ApartmentCommunity
    HomeCommunity
    say "Migrating Features from Property to PropertyFeaturesPage..."
    Community.all.each do |community|
      if community_have_feature?(community)
        say "Migrating Property #{community.id} #{community.title.inspect}"
        page = community.create_features_page({
          :text_1 => community.features_1_text,
          :title_1 => community.features_1_title,
          :text_2 => community.features_2_text,
          :title_2 => community.features_2_title,
          :text_3 => community.features_3_text,
          :title_3 => community.features_3_title,
          :meta_title => community.features_meta_title,
          :meta_description => community.features_meta_description,
          :meta_keywords => community.features_meta_keywords
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
    say "Migrating Features from PropertyFeaturesPage to Property..."
    Community.all.each do |community|
      if community.features_page.present?
        say "Migrating Property #{community.id} #{community.title.inspect}"
        community.update_attributes({
          :features_1_text => community.features_page.text_1,
          :features_1_title => community.features_page.title_1,
          :features_2_text => community.features_page.text_2,
          :features_2_title => community.features_page.title_2,
          :features_3_text => community.features_page.text_3,
          :features_3_title => community.features_page.title_3,
          :features_meta_title => community.features_page.meta_title,
          :features_meta_description => community.features_page.meta_description,
          :features_meta_keywords => community.features_page.meta_keywords
        })
      end
    end
  end
  
  private
  
  def self.community_have_feature?(community)
    community.features_1_text? || community.features_1_title? || community.features_2_title? ||
      community.features_2_text? || community.features_3_text? || community.features_3_title? ||
      community.features_meta_title? || community.features_meta_description? ||
      community.features_meta_keywords?
  end
end
