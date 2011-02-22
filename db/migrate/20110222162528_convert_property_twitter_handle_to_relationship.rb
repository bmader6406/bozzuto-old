class ConvertPropertyTwitterHandleToRelationship < ActiveRecord::Migration
  class Property < ActiveRecord::Base
  end

  class TwitterAccount < ActiveRecord::Base
  end


  def self.up
    add_column :properties, :twitter_account_id, :integer

    unless Rails.env.test?
      Property.all.each do |property|
        handle = property[:twitter_handle]

        if handle.present?
          # deal with handles like 'twitter.com/TheBozzutoGroup'
          handle = handle.split('/').last.strip

          say_with_time("Updating #{property.id}: #{property.title} (@#{handle})") do
            account = TwitterAccount.find_or_create_by_username(handle)

            property.update_attributes :twitter_account_id => account.id
          end
        end
      end
    end

    remove_column :properties, :twitter_handle
  end


  def self.down
    add_column :properties, :twitter_handle, :string

    unless Rails.env.test?
      Property.all.each do |property|
        account = TwitterAccount.find_by_id(property.twitter_account_id)

        if account.present?
          handle = account.username

          say_with_time("Updating #{property.id}: #{property.title} (@#{handle})") {
            property.update_attributes :twitter_handle => handle
          }
        end
      end
    end

    remove_column :properties, :twitter_account_id
  end
end
