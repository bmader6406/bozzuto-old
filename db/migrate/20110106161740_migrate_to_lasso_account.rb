class MigrateToLassoAccount < ActiveRecord::Migration
  def self.up
    say "Migrating Lasso from Property to LassoAccount..."
    HomeCommunity.all.each do |community|
      if community_have_lasso?(community)
        say "Migrating Property #{community.id} #{community.title.inspect}"
        lasso = community.create_lasso_account({
          :uid => community.lasso_uid,
          :project_id => community.lasso_project_id,
          :client_id => community.lasso_client_id
        })
        if lasso.new_record?
          say "LassoAccount failed to save: #{lasso.errors.full_messages.to_sentence}", true
        end
      end
    end
  end

  def self.down
    say "Migrating Lasso from LassoAccount to Property..."
    HomeCommunity.all.each do |community|
      if community.lasso_account.present?
        say "Migrating Property #{community.id} #{community.title.inspect}"
        community.update_attributes({
          :lasso_uid => community.lasso_account.uid,
          :lasso_project_id => community.lasso_account.project_id,
          :lasso_client_id => community.lasso_account.client_id
        })
      end
    end
  end
  
  private
  
  def self.community_have_lasso?(community)
    community.lasso_uid? && community.lasso_project_id? && community.lasso_client_id?
  end

  Property     = Class.new(ActiveRecord::Base)
  LassoAccount = Class.new(ActiveRecord::Base)

  class HomeCommunity < Property
    has_one :lasso_account
  end
end
