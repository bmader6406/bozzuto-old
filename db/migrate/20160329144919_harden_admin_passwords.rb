class HardenAdminPasswords < ActiveRecord::Migration
  def up
    AdminUser.find_each do |user|
      user.update_attributes(password: 'DYMgVhJepBhE-2KAu_358Q')
    end
  end
  
  def down
    # no op
  end

  class AdminUser < ActiveRecord::Base
    devise :database_authenticatable if defined?(Devise)
  end
end
