class MigrateToContactPage < ActiveRecord::Migration
  def self.up
    ApartmentCommunity
    HomeCommunity
    say "Migrating Contact from Property to PropertyContactPage..."
    Community.all.each do |community|
      if community_have_contact?(community)
        say "Migrating Property #{community.id} #{community.title.inspect}"
        page = community.create_contact_page({
          :content => community.contact_text,
          :meta_title => community.contact_meta_title,
          :meta_description => community.contact_meta_description,
          :meta_keywords => community.contact_meta_keywords
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
    say "Migrating Contact from PropertyContactPage to Property..."
    Community.all.each do |community|
      if community.contact_page.present?
        say "Migrating Property #{community.id} #{community.title.inspect}"
        community.update_attributes({
          :contact_text => community.contact_page.content,
          :contact_meta_title => community.contact_page.meta_title,
          :contact_meta_description => community.contact_page.meta_description,
          :contact_meta_keywords => community.contact_page.meta_keywords
        })
      end
    end
  end
  
  private
  
  def self.community_have_contact?(community)
    community.contact_text? || community.contact_meta_title? ||
      community.contact_meta_description? || community.contact_meta_keywords?
  end
end
