class MoveTypusUsersToAdminUsers < ActiveRecord::Migration
  def up
    TypusUser.find_each do |typus_user|
      successful = AdminUser.create(
        email:    typus_user.email,
        name:     [typus_user.first_name, typus_user.last_name].keep_if(&:present?).join(' '),
        password: 'password'
      )

      typus_user.destroy if successful
    end
  end

  def down
    AdminUser.find_each do |admin_user|
      first_name, last_name = admin_user.name.split(' ')
      successful            = TypusUser.create(
        email:       admin_user.email,
        first_name:  first_name,
        last_name:   last_name,
        status:      true,
        role:        'admin',
        preferences: { locale: 'en' },
        password:    'password'
      )

      admin_user.destroy if successful
    end
  end

  TypusUser = Class.new(ActiveRecord::Base)

  class AdminUser < ActiveRecord::Base
    devise :database_authenticatable
  end
end
